<template>
  <div>

    
    <div v-on:wheel.prevent="move($event)">

      <svg width="100%" height="50%"
          v-bind:viewBox="`${port.x_pos} ${port.y_pos} ${port.x_size} ${port.y_size}`" >

        <rect :x="port.x_min - 0.045*port.width"
              :y="port.y_min"
              :width="port.width + 0.085*port.width"
              :height="port.height"
              style="stroke: #000000; fill: none" ></rect>

        <transition-group v-if="this.data" tag="g" name="list">

          <g v-for="row_idx in data_info.nrows" 
            v-bind:key="row_idx"
            :id="`data_row${row_idx}`">

            <path 
              v-for="(_idx, i) in idxs.count "
              v-bind:key="(idxs.min + i) + row_idx / 100 "
              :id="(idxs.min + i) + row_idx / 100 "

              v-bind:d="path(row_idx, i)"

              stroke="black"
              :stroke-width="0.3"
              fill="none"
              >
            </path>

            <!-- <rect  -->
            <!--   v-for="(_idx, i) in idxs.count" -->
            <!--   v-bind:key="(idxs.min + i) + row_idx / 100 " -->
            <!--   :id="(idxs.min + i) + row_idx / 100 " -->
            <!--   v-bind:x="x_idx_pos(i) " -->
            <!--   v-bind:width="1.01" -->
            <!--   v-bind:y="y_idx_pos(row_idx) - signal_height*elem(row_idx,idxs.min+i) " -->
            <!--   v-bind:height="signal_height*elem(row_idx,idxs.min+i) + 0.5" -->

            <!--   :fill="colors[row_idx-1]" -->
            <!--   class="data-block" -->
            <!--   > -->
            <!-- </rect> -->


            <!--
              v-bind:stroke-width="data[row_idx][idxs.min+i]"
                -->
          </g>
        </transition-group>
      </svg>
    </div>

      <div>
	      Test: {{ tests }}
      </div>
  </div>

</template>

<script>
function idx(min) {
    let i = min;
    function idxer() {return i++; };
    return idxer;
}

export default {
    props: {
        xpos_frac: { default: 0.0, type: Number},
        width_count: { default: 50, type: Number},
        signal_height: { default: 3.18, type: Number},
        data_colors: { type: Object},
        data: { default: null, type: Array },
    },
    data: function() {
        return {
            strokeColor: "#1c2438",
            color_model: '',
            factor: 100,
        };
    },
    mounted: function() {
        var self = this;
        let nrows = this.data_info.nrows;
        let ncols = this.data_info.ncols;
        
        console.log("data: ", this.data);
    },
    
    computed: {
        
        indexed_cols: function() {
            return this.data_info.ncols / 10
        },
        data_info: function() {
            if (this.data === null || this.data.length == 0) return { ncols: 0, nrows: 0 }
            
            console.log("DI: ", this.data)
            let di = {
                ncols: this.data.map( d => d.length ).reduce( (x,y) => Math.min(x,y) ),
                nrows: this.data.length,
            }
            console.log("DI: ", di)
            return di;
        },
        
        colors: function() {
            let def_colors = {}
            for (var i = 0; i < this.data_info.nrows; i++) {
                def_colors[i] = '#1c2438'
            }
            
            let cl = Object.assign(def_colors, this.data_colors)
            console.log("update colors:", cl)
            return cl
        },
        
        port: function() {
            let width = this.data_info.ncols
            
            let x_min = 0.0
            let x_size = this.width_count // * this.data_info.ncols
            let x_pos = ((width - x_size) * this.xpos_frac).toFixed(3)
            
            let x_delta = this.data_info.ncols*1.0
            
            let y_min = 0.0
            let y_pos = 0.0
            let y_size = x_size/2
            let height = y_size / (this.data_info.nrows + 2)
            
            return {
                width, height, x_size, x_pos, y_size, y_pos, y_min, x_min, x_delta,
            }
        },
        
        idxs: function() {
            let idx_width = Math.ceil(this.port.x_size/2)
            // let idx_pos = Math.floor(this.port.x_pos)
            let idx_pos = Math.floor(this.port.x_pos / (idx_width)) * idx_width
            let idx_max = this.data_info.ncols - 1
            
            let min = Math.max(idx_pos - idx_width, 0)
            let max = Math.min(idx_max, idx_pos + 3*idx_width)
            
            let count = Math.floor( ( max - min ) / this.factor)
            
            let idxs = { min, max, count, idx_max}
            
            // console.log("idxes:", idxs)
            return idxs;
        },
        
    },
    methods: {
        path: function(row, col_idx) {
            let col = col_idx * this.factor
            let xpos = this.idxs.min + col + 1
            let ypos = (row+1) * this.port.height
            
            // let elem1 = 3*this.elem(row,this.idxs.min+col);
            
            let path = ` M ${xpos} ${ypos} `
            var prev = 0;
            for (var n = 0; n < this.factor + 1; n++) {
                let elem = ypos + this.port.height/3*this.elem(row,this.idxs.min+col+n)
                path += ` l 1 0 V ${elem} `
            }

            return path
        },
        elem: function(row, col) {
            return (this.data[row-1][Math.floor(col/8)] >>> (col %8)) & 1;
        },
        x_idx_width: function(idx) {
            return 1;
        },
        x_idx_pos: function(idx) {
            let xpos = this.idxs.min + idx + 1
            return xpos;
        },
        y_idx_pos: function(idx) {
            return 10*idx+5;
        },
        move: function ({deltaY: dY, deltaX: dX}) {
            let xf = this.xpos_frac
            // let xs = ( 0.8 * this.port.x_size ) - 6
            let xs = Math.log( 3* this.port.x_size ) - 2
            let mv = dY / 10 / this.port.width * xs
            let xpos_frac = Math.max(0.0, Math.min(1.0, xf + mv ));

            // console.log("xpos_frac:move:", xpos_frac)
            this.$emit("update:xpos_frac", xpos_frac)
      },
    }
  }
</script>

<style >
body {
    width: 100%;
    height: 100%;
    font-family: monospace;
}

.node {
    opacity: 1;
}

.node circle {
    fill: #999;
    cursor: pointer;
}

.node text {
    font: 10px sans-serif;
    cursor: pointer;
}

.node--internal circle {
    fill: #555;
}

.node--internal text {
    text-shadow: 0 1px 0 #fff, 0 -1px 0 #fff, 1px 0 0 #fff, -1px 0 0 #fff;
}

.link {
    fill: none;
    stroke: #555;
    stroke-opacity: 0.4;
    stroke-width: 1.5px;
    stroke-dasharray: 1000;
}

.node:hover {
    pointer-events: all;
    stroke: #ff0000;
}

.node.highlight {
    fill: red;
}

label {
    display: block;
}


</style>
