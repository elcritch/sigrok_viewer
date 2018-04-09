
<template>
  <div class="layout">

        <Layout>
            <Sider ref="side1" hide-trigger collapsible :collapsed-width="78" v-model="isCollapsed">
                <Menu active-name="1-2" theme="dark" width="auto" :class="menuitemClasses">
                    <MenuItem name="1-1">
                        <Icon type="ios-navigate"></Icon>
                        <span>Option 1</span>
                    </MenuItem>
                    <MenuItem name="1-2">
                        <Icon type="search"></Icon>
                        <span>Option 2</span>
                    </MenuItem>
                    <MenuItem name="1-3">
                        <Icon type="settings"></Icon>
                        <span>Option 3</span>
                    </MenuItem>
                </Menu>
            </Sider>
            <Layout>
                <!-- <Header :style="{padding: 0}" class="layout-header-bar"> -->
                    <!-- <Icon @click.native="collapsedSider" :class="rotateIcon" :style="{margin: '20px 20px 0'}" type="navicon-round" size="24"></Icon> -->
                <!-- </Header> -->
                <Content :style="{margin: '20px', background: '#fff', minHeight: '80%'}">
                    Content...

                    <!-- UI controls that can are used to manipulate the display of the chart -->


                      <Row :gutter="16">
                        <Col span="10">
                          <Card class="controls">
                            <label slot="title">Position Settings</label>

                              <label>Graph Postion: {{`${(100*user_view.xpos_frac).toFixed(1)}%`}}</label>
                              <Slider v-model="user_view.xpos_frac"
                                      :min="0.0"
                                      :max="1.0"
                                      :step="0.000001"
                                      :tip-format="v => `Position: ${(100*v).toFixed(1)}%`"
                                      show-input
                                    ></Slider>
                              <label>Number Elements Displayed: {{user_view.width_count}}</label>
                              <Slider v-model="user_view.width_count"
                                      :min="10"
                                      :max="1000"
                                      :step="1"
                                      :tip-format="v => `Count: ${v}`"
                                      show-stops
                                      show-input
                                    > </Slider>
                          </Card>
                        </Col>

                        <Col span="10">
                          <Card class="controls">
                            <label slot="title">Signal's</label>
                            <Row justify="start">
                              <Col span="8">
                                <Select v-model="settings.color_item" >
                                  <Option v-for="item in settings.colors"
                                          :value="item.value"
                                          :key="item.value">
                                    {{ item.label }}
                                  </Option>
                                </Select>
                              </Col>
                              <Col span="4">
                              <ColorPicker v-model="settings.strokeColor"
                                           v-on:on-change="updateColor"
                                           recommend></ColorPicker>
                              </Col>
                            </Row>
                          </Card>
                        </Col>
                      </Row>

                      <div> Selected: {{ selected }} </div>
                    </Card>

                    <SvgChart :data="datum"
                              :xpos_frac.sync="user_view.xpos_frac"
                              :width_count.sync="user_view.width_count"
                              :data_colors.sync="selected_colors"

                              >
                    </SvgChart>

                </Content>
            </Layout>
        </Layout>
    </div>

</template>

<script>

function rand(min, max) {
    return Math.round(Math.random() * (max - min) + min);
}

import RandomChart from './RandomChart.vue'
import SvgChart from './SvgChart.vue'

export default {
    components: {
        SvgChart
    },
    data () {
        return {
            value: [20, 50],
            datum: [],
            user_view: {
                xpos_frac: 0.0,
                width_count: 10,
            },
            datum: null,
            settings: {
                strokeColor: "",
                colors: [],
                color_item: null,
            },
            nrows: 4,
            ncols: 10000,
            selected_colors: {},
        }
    },
    mounted: function() {
        
        var self = this
        let nrows = this.nrows
        let ncols = this.ncols
        
        // datum
        this.datum = Array(nrows).fill(0).
            map((i) => {return new Int8Array(new ArrayBuffer(ncols));});
        
        this.datum.map( (d) => {
            for (var i = 0; i < ncols; i++) {
                d[i] = rand(0,128)
                // d[i] = i % 254
            }
        });
        
        for (var i = 0; i < ncols; i++) {
            this.datum[0][i] = 0xAA;
            // d[i] = i % 254
        }
        
        
        for (var i = 0; i < nrows; i++) {
            this.settings.colors[i] = { label: `Row ${i}`, value: i}
        }
        
        console.log("dataum: ", this.datum[0]);
        
    },
    methods: {
        updateColor: function() {
            if (this.settings.color_item !== null) {
                this.selected_colors = Object.assign({}, this.selected_colors, { [this.settings.color_item]: this.settings.strokeColor })
                console.log("color:updated:", this.selected_colors)
                this.$Message.success(`Color updated for ${this.settings.color_item} `)
          }
        }
    },
}
</script>


<style >
    html, body, .layout, #vue-app, .ivu-layout {
        width: 100%;
        height: 100%;
        margin: 0;
      }

    .layout{
        border: 1px solid #d7dde4;
        background: #f5f7f9;
        position: relative;
        border-radius: 4px;
        overflow: hidden;
    }
    .layout-header-bar{
        background: #fff;
        box-shadow: 0 1px 1px rgba(0,0,0,.1);
    }
    .layout-logo-left{
        width: 90%;
        height: 30px;
        background: #5b6270;
        border-radius: 3px;
        margin: 15px auto;
    }
    .menu-icon{
        transition: all .3s;
    }
    .rotate-icon{
        transform: rotate(-90deg);
    }
    .menu-item span{
        display: inline-block;
        overflow: hidden;
        width: 69px;
        text-overflow: ellipsis;
        white-space: nowrap;
        vertical-align: bottom;
        transition: width .2s ease .2s;
    }
    .menu-item i{
        transform: translateX(0px);
        transition: font-size .2s ease, transform .2s ease;
        vertical-align: middle;
        font-size: 16px;
    }
    .collapsed-menu span{
        width: 0px;
        transition: width .2s ease;
    }
    .collapsed-menu i{
        transform: translateX(5px);
        transition: font-size .2s ease .2s, transform .2s ease .2s;
        vertical-align: middle;
        font-size: 22px;
    }
</style>
