<template>
  <div class="line-chart-space">
    <line-chart :option="TrafficInChart" :_id="'traffIn'" ref="echartIn">
    </line-chart>

    <!-- <q-separator class="my-5" /> -->

    <line-chart :option="TrafficOutChart" :_id="'traffOut'" ref="echartOut">
    </line-chart>
  </div>
</template>
<script>
// import OptionChart from "@/views/components/OptionChart.vue";
// import AppWidget from "@/views/widget/AppWidget.vue";
import moment from 'moment';
import axios from 'axios';
import { ref, defineAsyncComponent } from 'vue';

export default {
  components: {
    // OptionChart,
    // AppWidget,
    LineChart: defineAsyncComponent(() =>
      import('src/components/charts/LineChart.vue')
    ),
  },
  props: {
    TrafficIn: Array,
    TrafficOut: Array,
    message: String,
  },
  data() {
    return {
      TrafficInChart: {
        xAxis: {
          type: 'category',
          boundaryGap: false,
          data: [1, 2, 3],
          axisLabel: {
            formatter: function (d) {
              return d.split(' ')[1];
            },
          },
        },
        title: [
          {
            left: 'center',
            text: 'Traffic Rate In',
          },
          {
            show: false,
            text: 'No data',
            left: 'center',
            top: 'center',
          },
        ],
        grid: {
          bottom: '30%',
        },
        legend: {
          //   data: [],
          type: 'scroll',
          orient: 'horizontal',
          bottom: 0,
        },
        yAxis: {
          type: 'value',
          axisLabel: {
            formatter: '{value} Kbps',
          },
          boundaryGap: [0, '30%'],
        },
        tooltip: {
          trigger: 'axis',
          position: function (pt) {
            return [pt[0] + 20, '10%'];
          },
        },

        dataZoom: [
          {
            type: 'inside',
            start: 0,
            end: 100,
            bottom: 40,
          },
          {
            start: 0,
            end: 100,
            bottom: 40,
            labelFormatter: function (value, valueStr) {
              return valueStr.split(' ')[1];
            },
          },
        ],
        toolbox: {
          feature: {
            saveAsImage: {
              title: 'save as image',
            },
            // dataZoom: {
            //   show: true,
            //   yAxisIndex: "none",
            //   title: { zoom: "zoom in", back: "zoom\nout" },
            // },
          },
        },

        series: [],
      },
      TrafficOutChart: {
        xAxis: {
          type: 'category',
          boundaryGap: false,
          data: [1, 2, 3],
          axisLabel: {
            formatter: function (d) {
              return d.split(' ')[1];
            },
          },
        },
        title: [
          {
            left: 'center',
            text: 'Traffic Rate Out',
          },
          {
            show: false,
            text: 'No data',
            left: 'center',
            top: 'center',
          },
        ],
        grid: {
          bottom: '30%',
        },
        legend: {
          //   data: [],
          type: 'scroll',
          orient: 'horizontal',
          bottom: 0,
        },
        yAxis: {
          type: 'value',
          axisLabel: {
            formatter: '{value} Kbps',
          },
          boundaryGap: [0, '30%'],
        },
        tooltip: {
          trigger: 'axis',
          position: function (pt) {
            return [pt[0] + 20, '-30%'];
          },
        },
        dataZoom: [
          {
            type: 'inside',
            start: 0,
            end: 100,
            bottom: 40,
          },
          {
            start: 0,
            end: 100,
            bottom: 40,
            labelFormatter: function (value, valueStr) {
              return valueStr.split(' ')[1];
            },
          },
        ],
        toolbox: {
          feature: {
            show: true,
            saveAsImage: {
              title: 'save as image',
            },
            // dataZoom: {
            //   show: true,
            //   yAxisIndex: "none",
            //   //  icon: { zoom: 'image://https://img.icons8.com/external-kiranshastry-lineal-kiranshastry/64/000000/external-zoom-in-interface-kiranshastry-lineal-kiranshastry.png', back: 'image://https://img.icons8.com/external-kiranshastry-lineal-kiranshastry/64/000000/external-zoom-out-interface-kiranshastry-lineal-kiranshastry.png'},

            //   title: { zoom: "zoom in", back: "zoom\nout" },
            // },
          },
        },

        series: [],
      },

      search: '',
      timeArray: [],
      upArray: [],
      downArray: {},
      headers: [
        {
          text: 'Name',
          align: 'start',
          value: 'name',
        },
        { text: 'Status', value: 'status' },
        { text: 'Enabled', value: 'enabled' },
        { text: 'Type', value: 'type' },
        { text: 'IP Address', value: 'ip' },
      ],
      assets: [],
    };
  },
  created() {
    this.initialize();
  },
  methods: {
    delay() {
      setTimeout(() => this.loaded(), 1000);
    },
    initialize() {
      this.TrafficInChart.series = [];
      this.TrafficOutChart.series = [];

      if (this.TrafficIn.length && this.TrafficOut.length) {
        this.TrafficOutChart.title[1].show = false;
        this.TrafficInChart.title[1].show = false;
        var i, j;
        this.TrafficInChart.xAxis.data = this.TrafficIn[0].traffic.map(
          (item) => {
            return this.formatDate(item['time']);
          }
        );
        this.TrafficInChart.legend.data = this.TrafficIn.map(function (item) {
          return item['name'];
        });
        for (i in this.TrafficIn) {
          // legendA.push(TrafficIn[i].name)
          // this.timeArray.push(TrafficIn[i])

          this.TrafficInChart.series.push({
            name: this.TrafficIn[i].name,
            data: this.TrafficIn[i].traffic.map(function (item) {
              return item['kbps'];
            }),
            type: 'line',
            showSymbol: false,
            areaStyle: {},
            emphasis: { focus: 'series' },
          });
          //this.TrafficIn[i].traffic.map(function(item) { return this.formatDate(item["time"]); });
        }
        this.TrafficOutChart.xAxis.data = this.TrafficOut[0].traffic.map(
          (item) => {
            return this.formatDate(item['time']);
          }
        );
        this.TrafficOutChart.legend.data = this.TrafficOut.map(function (item) {
          return item['name'];
        });
        for (j in this.TrafficOut) {
          this.TrafficOutChart.series.push({
            name: this.TrafficOut[j].name,
            data: this.TrafficOut[j].traffic.map(function (item) {
              return item['kbps'];
            }),
            type: 'line',
            showSymbol: false,
            areaStyle: {},
            emphasis: { focus: 'series' },
          });
        }
      } else {
        this.TrafficOutChart.xAxis.data = [];
        this.TrafficInChart.xAxis.data = [];
        console.log('message' + this.message);
        this.TrafficOutChart.title[1].text = this.message;
        this.TrafficInChart.title[1].text = this.message;
        this.TrafficOutChart.title[1].show = true;
        this.TrafficInChart.title[1].show = true;
      }
    },
    initializingTraffic: function (siteID) {
      this.$refs.echartIn.isLoading(siteID);
      this.$refs.echartOut.isLoading(siteID);
    },
    initTraffic: function (siteID) {
      console.log('refresh: ' + siteID);
      this.delay();
    },
    loaded() {
      this.$refs.echartIn.Chartloaded('loaded');
      this.$refs.echartOut.Chartloaded('loaded');
      this.initialize();
    },
    refreshChartT: function (siteID) {
      console.log('redraw SNMP: ' + siteID);
      this.$refs.echartIn.RedrawChart(siteID);
      this.$refs.echartOut.RedrawChart(siteID);
    },
    formatDate(date) {
      var offset = moment().utcOffset();
      return moment.utc(date).utcOffset(offset).format('YYYY-MM-DD HH:mm');
    },
    getColor(date) {
      if (!moment(date).isBefore(moment(), 'day')) return 'green';
      else return 'yellow';
    },
  },
};
</script>

<style scoped>
.line-chart-space {
  display: grid;
  gap: 1em;
}
</style>
