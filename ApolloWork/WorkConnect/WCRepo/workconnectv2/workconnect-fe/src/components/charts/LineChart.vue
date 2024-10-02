<template>
  <div>
    <q-card>
      <!-- <q-card-section class="text-h6">
        Line Chart
      </q-card-section> -->
      <q-card-section class="q-pa-none">
        <div :id="_id" style="height: 300px"></div>
      </q-card-section>
      <q-resize-observer @resize="onResize" />
      <template #loading>
        <q-inner-loading showing color="secondary" />
      </template>
    </q-card>
  </div>
</template>

<script>
import * as echarts from 'echarts';

export default {
  name: 'LineChart',
  props: {
    series: Array,
    xaxis_data: Array,
    legend_data: Array,
    option: Object,
    _id: String,
  },
  data() {
    return {
      lineChart: null,
      chart_data: this.option,
      model: false,
    };
  },
  mounted() {
    this.init();
    this.load_data();
  },
  watch: {
    '$q.dark.isActive': function () {
      this.init();
    },
    option: {
      deep: true,
      handler(val) {
        this.setOptions(val);
      },
    },
  },
  methods: {
    init() {
      if (this.option != null) {
        this.lineChart = document.getElementById(this._id);
        echarts.dispose(this.lineChart);
        let theme = this.model ? 'dark' : 'light';
        this.line_chart = echarts.init(this.lineChart, theme);
        this.setOptions(this.option);
      } else {
        this.lineChart = document.getElementById('lineChart');
        echarts.dispose(this.lineChart);
        let theme = this.model ? 'dark' : 'light';
        this.line_chart = echarts.init(this.lineChart, theme);
        this.setOptions(this.LineChart);
      }
    },
    onResize() {
      if (this.line_chart) {
        this.line_chart.resize();
      }
    },
    X_axis_dateFormatter(val) {
      let temp = [];
      for (let i = 0; i < val.length; i++) {
        temp[i] = echarts.format.formatTime('yyyy-MM-dd hh:mm', val[i]);
      }
      return temp;
    },
    isLoading: function (load) {
      console.log('chart Loading' + load);
      this.line_chart.showLoading('default', this.default);
    },
    Chartloaded: function (load) {
      console.log('chart Loaded' + load);
      this.line_chart.hideLoading();
    },
    RedrawChart: function (load) {
      console.log('chart redraws' + load);
      this.line_chart.resize();
    },
    delay() {
      setTimeout(() => this.line_chart.hideLoading(), 2500);
    },
    setOptions(option = {}) {
      this.line_chart.setOption(option);
    },
    initChart() {
      if (this.option != null) {
        this.lineChart = document.getElementById(this._id);
        echarts.dispose(this.lineChart);
        let theme = this.model ? 'dark' : 'light';
        this.line_chart = echarts.init(this.lineChart, theme);
        this.setOptions(this.option);
      } else {
        this.lineChart = document.getElementById('lineChart');
        echarts.dispose(this.lineChart);
        let theme = this.model ? 'dark' : 'light';
        this.line_chart = echarts.init(this.lineChart, theme);
        this.setOptions(this.LineChart);
      }
    },
    load_data() {
      if (
        this.series != null &&
        this.xaxis_data != null &&
        this.legend_data != null
      ) {
        console.log('yey! data');
        this.LineChart.xAxis.data = this.X_axis_dateFormatter(this.xaxis_data);
        this.LineChart.legend.data = this.legend_data;
        var i;
        this.LineChart.series = [];
        for (i in this.series) {
          this.LineChart.series.push({
            name: this.series[i].name,
            type: 'line',
            smooth: true,
            data: this.series[i].data,
            showSymbol: true,
            areaStyle: {},
            emphasis: { focus: 'series' },
          });
        }
        this.line_chart.setOption(this.LineChart);
      } else {
        console.log('boo! no data');
      }
    },
  },
  setup() {
    return {
      LineChart: {
        tooltip: {
          trigger: 'axis',
          textStyle: {
            fontSize: 9,
            fontFamily: 'arial',
          },
          // position:[0,300], or position:['50%',"50%  "],
          position: function (pt) {
            return [pt[0] - 190, 130];
          },
          axisPointer: {
            type: 'cross',
            label: { backgroundColor: '#6a7985' },
          },
        },
        legend: {
          bottom: 40,
          data: ['Line 1', 'Line 2', 'Line 3', 'Line 4', 'Line 5'],
        },
        title: {
          show: true,
          textStyle: { color: 'rgba(0, 0, 0 , .87)', fontFamily: 'sans-serif' },
        },
        dataZoom: [
          {
            type: 'inside',
            start: 0,
            end: 10,
          },
          {
            start: 0,
            end: 10,
          },
        ],
        grid: {
          left: '7%',
          right: '4%',
          bottom: '40%',
          top: '5%',
        },

        xAxis: {
          show: false,
          type: 'category',
          axisLine: {
            lineStyle: { color: 'rgba(0, 0, 0 , .54)', type: 'dashed' },
          },
          axisTick: {
            show: true,
            alignWithLabel: true,
            lineStyle: {
              show: true,
              color: 'rgba(0, 0, 0 , .54)',
              type: 'dashed',
            },
          },
          axisLabel: { show: false },
          boundaryGap: false,
        },
        yAxis: {
          show: true,
          type: 'value',
          axisLine: {
            lineStyle: { color: 'rgba(0, 0, 0 , .54)', type: 'dashed' },
          },
          axisLabel: { show: true, formatter: '{value} kbps' },
          splitLine: { lineStyle: { type: 'dashed' } },
          axisTick: {
            show: true,
            lineStyle: {
              show: true,
              color: 'rgba(0, 0, 0 , .54)',
              type: 'dashed',
            },
          },
          boundaryGap: [0, '100%'],
        },
        color: ['#2196f3'],
      },
      line_chart: null,
    };
  },
};
</script>

<style></style>
