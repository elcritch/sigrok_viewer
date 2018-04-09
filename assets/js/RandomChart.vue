<template>
  <div class="small">
    <line-chart :chart-data="datacollection"
                :options="{}">
    </line-chart>
    <button @click="fillData()">Randomize</button>
  </div>
</template>

<script>

  import LineChart from './LineChart.js'

  export default {
    components: {
      LineChart
    },
    data () {
      return {
        count: 50,
        datacollection: null
      }
    },
    mounted () {
      this.fillData()

        var self = this

        setInterval(function () {
          self.shiftData()
        }, 1000);
    },

    methods: {
      shiftData () {
          var dc = Object.assign({}, this.datacollection)

          var d0 = dc.datasets[0].data

          console.log("update data pre: " + d0);
          d0.unshift(this.getRandomInt());
          console.log("update data post: " + d0);

          if ( d0.length >= this.count) {
            d0.pop();
            console.log("data pop " );
          }

          this.datacollection = dc;

          console.log("update data");
      },
      fillData () {
        this.datacollection = {
          labels: Array(this.count).fill().map(this.getRandomInt), 
          datasets: [
            {
              label: 'Data One',
              backgroundColor: '#f87979',
              data: Array(this.count).fill().map(this.getRandomInt),
            },
          ]
        }
      },
      getRandomInt () {
        return Math.floor(Math.random() * (50 - 5 + 1)) + 5
      }
    }
  }
</script>

<style>
  .small {
    max-width: 600px;
    margin:  150px auto;
  }
</style>
