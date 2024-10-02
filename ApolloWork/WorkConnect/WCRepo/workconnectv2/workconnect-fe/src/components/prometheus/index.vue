<template>
  <div class="line-chart-space">
    <div v-if="loopback0H.length > 0">
      <line-chart :option="loopback0" :_id="'loopback0'" ref="loopback0chart">
      </line-chart>
    </div>

    <div v-if="loopback1H.length > 0">
      <line-chart :option="loopback1" :_id="'loopback1'" ref="loopback1chart">
      </line-chart>
    </div>

    <div v-if="loopback2H.length > 0">
      <line-chart :option="loopback2" :_id="'loopback2'" ref="loopback2chart">
      </line-chart>
    </div>

    <div v-if="loopback3H.length > 0">
      <line-chart :option="loopback3" :_id="'loopback3'" ref="loopback3chart">
      </line-chart>
    </div>
  </div>
</template>
<script>
import moment from 'moment';
import { defineAsyncComponent, defineComponent } from 'vue';

export default {
  components: {
    // OptionChart,
    // AppWidget,
    LineChart: defineAsyncComponent(() =>
      import('src/components/charts/LineChart.vue')
    ),
  },

  props: {
    loopback0H: Array,
    loopback1H: Array,
    loopback2H: Array,
    loopback3H: Array,
  },
  data() {
    return {
      loopback0: {
        title: [
          {
            left: 'center',
            text: 'Loopback',
          },
          {
            show: false,
            text: 'No data',
            left: 'center',
            top: 'center',
          },
        ],
        xAxis: {
          type: 'category',
          boundaryGap: false,
          data: [],
          axisLabel: {
            formatter: function (d) {
              return d.split(' ')[1];
            },
          },
        },
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
          max: 1.5,
          min: 0,
          interval: 0.5,
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
        tooltip: {
          trigger: 'axis',
          position: function (pt) {
            return [pt[0], '10%'];
          },
        },
        toolbox: {
          feature: {
            show: true,
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

        series: [
          {
            data: [],
            type: 'line',
            step: 'start',
            symbol: 'none',
            itemStyle: { color: 'blue' },
            areaStyle: {
              opacity: 0.3,
            },
          },
        ],
      },
      loopback1: {
        title: [
          {
            left: 'center',
            text: 'Loopback',
            subtext: '',
          },
          {
            show: false,
            text: 'No data',
            left: 'center',
          },
        ],
        xAxis: {
          type: 'category',
          boundaryGap: false,
          data: [],
          axisLabel: {
            formatter: function (d) {
              return d.split(' ')[1];
            },
          },
        },
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
          max: 1.5,
          min: 0,
          interval: 0.5,
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
        tooltip: {
          trigger: 'axis',
          position: function (pt) {
            return [pt[0], '10%'];
          },
        },
        toolbox: {
          feature: {
            show: true,
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

        series: [
          {
            data: [],
            type: 'line',
            step: 'start',
            symbol: 'none',
            itemStyle: { color: 'blue' },
            areaStyle: {
              opacity: 0.3,
            },
          },
        ],
      },
      loopback2: {
        title: [
          {
            left: 'center',
            text: 'Loopback',
          },
          {
            show: false,
            text: 'No data',
            left: 'center',
            top: 'center',
          },
        ],
        xAxis: {
          type: 'category',
          boundaryGap: false,
          data: [],
          axisLabel: {
            formatter: function (d) {
              return d.split(' ')[1];
            },
          },
        },
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
          max: 1.5,
          min: 0,
          interval: 0.5,
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
        tooltip: {
          trigger: 'axis',
          position: function (pt) {
            return [pt[0], '10%'];
          },
        },
        toolbox: {
          feature: {
            show: true,
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

        series: [
          {
            data: [],
            type: 'line',
            step: 'start',
            symbol: 'none',
            itemStyle: { color: 'blue' },
            areaStyle: {
              opacity: 0.3,
            },
          },
        ],
      },
      loopback3: {
        title: [
          {
            left: 'center',
            text: 'Loopback',
          },
          {
            show: false,
            text: 'No data',
            left: 'center',
            top: 'center',
          },
        ],
        xAxis: {
          type: 'category',
          boundaryGap: false,
          data: [],
          axisLabel: {
            formatter: function (d) {
              return d.split(' ')[1];
            },
          },
        },
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
          max: 1.5,
          min: 0,
          interval: 0.5,
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
        tooltip: {
          trigger: 'axis',
          position: function (pt) {
            return [pt[0], '10%'];
          },
        },
        toolbox: {
          feature: {
            show: true,
            right: '200px',
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

        series: [
          {
            data: [],
            type: 'line',
            step: 'start',
            symbol: 'none',
            itemStyle: { color: 'blue' },
            areaStyle: {
              opacity: 0.3,
            },
          },
        ],
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
    initialize() {
      console.log('P init');
      console.log(
        this.loopback0H,
        this.loopback1H,
        this.loopback2H,
        this.loopback3H
      );

      this.timeArray = [];
      this.upArray = [];
      var i;
      if (this.loopback0H.length > 0) {
        for (i in this.loopback0H[0].history) {
          this.timeArray.push(
            this.formatDate(this.loopback0H[0].history[i].date)
          );
          this.upArray.push(this.loopback0H[0].history[i].status);
        }

        this.loopback0.xAxis.data = this.timeArray;
        this.loopback0.series[0].data = this.upArray;
        this.loopback0.title[0].text = 'loopback 0';
        this.loopback0.title[0].subtext = this.loopback0H[0].loopback0_ip;
      }

      this.timeArray = [];
      this.upArray = [];

      if (this.loopback1H.length > 0) {
        for (i in this.loopback1H[0].history) {
          this.timeArray.push(
            this.formatDate(this.loopback1H[0].history[i].date)
          );
          this.upArray.push(this.loopback1H[0].history[i].status);
        }

        this.loopback1.xAxis.data = this.timeArray;
        this.loopback1.series[0].data = this.upArray;
        this.loopback1.title[0].text = 'loopback 1';
        this.loopback1.title[0].subtext = this.loopback1H[0].loopback1_ip;
      }

      this.timeArray = [];
      this.upArray = [];

      if (this.loopback2H.length > 0) {
        for (i in this.loopback2H[0].history) {
          this.timeArray.push(
            this.formatDate(this.loopback2H[0].history[i].date)
          );
          this.upArray.push(this.loopback2H[0].history[i].status);
        }

        this.loopback2.xAxis.data = this.timeArray;
        this.loopback2.series[0].data = this.upArray;
        this.loopback2.title[0].text = 'loopback 2';
        this.loopback2.title[0].subtext = this.loopback2H[0].loopback2_ip;
      }

      this.timeArray = [];
      this.upArray = [];

      if (this.loopback3H.length > 0) {
        for (i in this.loopback3H[0].history) {
          this.timeArray.push(
            this.formatDate(this.loopback3H[0].history[i].date)
          );
          this.upArray.push(this.loopback3H[0].history[i].status);
        }

        this.loopback3.xAxis.data = this.timeArray;
        this.loopback3.series[0].data = this.upArray;
        this.loopback3.title[0].text = 'loopback 3';
        this.loopback3.title[0].subtext = this.loopback3H[0].loopback3_ip;
      }
    },
    //zoomRoute: function(value) {
    initP: function (loopback0H, loopback1H, loopback2H, loopback3H) {
      console.log(loopback0H);
      console.log(loopback1H);
      console.log(loopback2H);
      console.log(loopback3H);
      console.log('init');
      var i;
      for (i in loopback0H.history) {
        this.timeArray.push(loopback0H.history[i].date);
        this.upArray.push(loopback0H.history[i].status);
      }
    },
    delay() {
      setTimeout(() => this.loaded(), 500);
    },
    initializingHistory: function (siteID) {
      if (this.loopback0H.length > 0)
        this.$refs.loopback0chart.isLoading(siteID);
      if (this.loopback1H.length > 0)
        this.$refs.loopback1chart.isLoading(siteID);
      if (this.loopback2H.length > 0)
        this.$refs.loopback2chart.isLoading(siteID);
      if (this.loopback3H.length > 0)
        this.$refs.loopback3chart.isLoading(siteID);
    },
    initHistory: function (siteID) {
      console.log('refresh: ' + siteID);
      this.delay();
    },
    refreshChart: function (siteID) {
      console.log('redraw Prometheus: ' + siteID);
      if (this.loopback0H.length > 0)
        this.$refs.loopback0chart.RedrawChart(siteID);
      if (this.loopback1H.length > 0)
        this.$refs.loopback1chart.RedrawChart(siteID);
      if (this.loopback2H.length > 0)
        this.$refs.loopback2chart.RedrawChart(siteID);
      if (this.loopback3H.length > 0)
        this.$refs.loopback3chart.RedrawChart(siteID);
    },
    loaded() {
      if (this.loopback0H.length > 0)
        this.$refs.loopback0chart.Chartloaded('loaded');
      if (this.loopback1H.length > 0)
        this.$refs.loopback1chart.Chartloaded('loaded');
      if (this.loopback2H.length > 0)
        this.$refs.loopback2chart.Chartloaded('loaded');
      if (this.loopback3H.length > 0)
        this.$refs.loopback3chart.Chartloaded('loaded');
      this.initialize();
    },
    formatDate(date) {
      var offset = moment().utcOffset();
      return moment
        .utc(date, 'MMM DD YYYY HH:mm:ss.SSS zzz')
        .utcOffset(offset)
        .format('YYYY-MM-DD HH:mm');
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
