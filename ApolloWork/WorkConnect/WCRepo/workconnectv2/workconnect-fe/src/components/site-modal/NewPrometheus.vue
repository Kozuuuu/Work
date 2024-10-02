<template>
  <div>
    <div class="row cursor-pointer">
      <q-input
        v-model="dateRangeTextP"
        label="Date"
        prepend-icon="mdi-calendar"
        readonly
      >
        <template #prepend>
          <q-icon name="event" class="cursor-pointer"></q-icon>
          <q-popup-proxy
            ref="qDateProxy"
            cover
            transition-show="scale"
            transition-hide="scale"
          >
            <q-date v-model="dateRangeP" minimal range>
              <q-space></q-space>
              <div align="right">
                <q-btn flat label="Cancel" color="primary" v-close-popup>
                </q-btn>
                <q-btn
                  flat
                  label="OK"
                  color="primary"
                  @click="selectDateP()"
                  v-close-popup
                >
                </q-btn>
              </div>
            </q-date>
          </q-popup-proxy>
        </template>
        <template #append>
          <q-icon
            name="arrow_back"
            class="cursor-pointer"
            @click="previousDayP()"
          ></q-icon>

          <q-icon
            name="arrow_forward"
            class="cursor-pointer"
            @click="nextDayP()"
          ></q-icon>
        </template>
      </q-input>
    </div>

    <div
      v-if="historiesP.length === 0 && historiesP"
      class="text-grey-5"
      align="center"
    >
      {{ messageP }}
    </div>

    <Prometheus
      :loopback0H="loopback0H"
      :loopback1H="loopback1H"
      :loopback2H="loopback2H"
      :loopback3H="loopback3H"
      ref="PrometheusChartRef"
    />
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, watch, onMounted } from 'vue';
import Prometheus from 'src/components/prometheus/index.vue';
import { useQuasar } from 'quasar';
import { getHistoryPrometheusApi } from 'src/api/testApi';
export default defineComponent({
  components: { Prometheus },
  props: ['siteId'],

  setup(props) {
    const $q = useQuasar();
    const dateRangeTextP = ref('');
    const dateRangeP = ref(['', '']);
    const loopback0H = ref([]);
    const loopback1H = ref([]);
    const loopback2H = ref([]);
    const loopback3H = ref([]);
    const messageP = ref('');
    const historiesP = ref([]);
    const DatePickerP = ref(false);
    const PrometheusChartRef = ref(null);
    const dateP = ref('');
    let selectedItem = props.siteId;
    const historyHoursP = ref(1);
    const gettingHistoriesP = ref(false);
    const tabsHistory = ref('Prometheus');
    const serverTimeout = ref(false);
    const date = ref('');
    const dateRange = ref(['', '']);
    const dateRangeText = ref('');

    function selectDateP() {
      const dateRangeProm = Object.values(dateRangeP.value);
      if (dateRangeProm.length > 0) {
        if (dateRangeProm.length == 1) dateRangeProm[1] = dateRangeProm[0];
        DatePickerP.value = false;
        const diffInDays =
          (new Date(dateRangeProm[0]) - new Date(dateRangeProm[1])) / 86400000;
        if (diffInDays >= 0) {
          dateP.value = dateRangeProm[0].replaceAll('/', '-');
          historyHoursP.value = diffInDays + 1;
          dateRangeProm.reverse();
        } else {
          dateP.value = dateRangeProm[1].replaceAll('/', '-');
          historyHoursP.value = diffInDays * -1 + 1;
        }
        getHistoryPrometheus();
      }
      dateRangeP.value = Object.assign({}, dateRangeProm);
    }

    function previousDayP() {
      var result = new Date(dateP.value);
      result.setDate(result.getDate() - 1);
      dateP.value = new Date(result - new Date().getTimezoneOffset() * 60000)
        .toISOString()
        .substr(0, 10);
      result = new Date(dateRangeP.value[0]);
      result.setDate(result.getDate() - 1);
      dateRangeP.value[0] = new Date(
        result - new Date().getTimezoneOffset() * 60000
      )
        .toISOString()
        .substr(0, 10);
      result = new Date(dateRangeP.value[1]);
      result.setDate(result.getDate() - 1);
      dateRangeP.value[1] = new Date(
        result - new Date().getTimezoneOffset() * 60000
      )
        .toISOString()
        .substr(0, 10);
      getHistoryPrometheus();
    }

    function nextDayP() {
      var result = new Date(dateP.value);
      result.setDate(result.getDate() + 1);
      dateP.value = new Date(result - new Date().getTimezoneOffset() * 60000)
        .toISOString()
        .substr(0, 10);
      result = new Date(dateRangeP.value[0]);
      result.setDate(result.getDate() + 1);
      dateRangeP.value[0] = new Date(
        result - new Date().getTimezoneOffset() * 60000
      )
        .toISOString()
        .substr(0, 10);
      result = new Date(dateRangeP.value[1]);
      result.setDate(result.getDate() + 1);
      dateRangeP.value[1] = new Date(
        result - new Date().getTimezoneOffset() * 60000
      )
        .toISOString()
        .substr(0, 10);
      getHistoryPrometheus();
    }

    async function getHistoryPrometheus() {
      const dateRangeProm = Object.values(dateRangeP.value);
      dateRangeTextP.value = dateRangeProm.join(' ~ ').replaceAll('/', '-');
      // historiesP.value = [];
      gettingHistoriesP.value = true;
      if (tabsHistory.value === 'Prometheus')
        PrometheusChartRef.value.initializingHistory(selectedItem);
      try {
        historiesP.value = await getHistoryPrometheusApi(
          selectedItem,
          24 * historyHoursP.value,
          dateP.value
        );
        console.log('test: ', historiesP.value);
        if (historiesP.value.error_message) {
          console.log('historiesP.value: ', historiesP.value);
          messageP.value = historiesP.value.error_message;
          $q.notify({
            type: 'negative',
            message: 'Error Getting Prometheus History',
          });
          historiesP.value = [];
        }

        loopback0H.value = historiesP.value.filter((item) => {
          return item.loopback0 != null;
        });
        loopback1H.value = historiesP.value.filter((item) => {
          return item.loopback1 != null;
        });
        loopback2H.value = historiesP.value.filter((item) => {
          return item.loopback2 != null;
        });
        loopback3H.value = historiesP.value.filter((item) => {
          return item.loopback3 != null;
        });
        if (tabsHistory.value === 'Prometheus')
          PrometheusChartRef.value.initHistory(loopback0H.value.length);
        gettingHistoriesP.value = false;
      } catch (error) {
        console.log(error);
        $q.notify({
          type: 'negative',
          message: 'Error Getting Prometheus History',
        });
        serverTimeout.value = true;
        gettingHistoriesP.value = false;
      }
    }
    async function displayDevice(item) {
      getHistoryPrometheus();
    }

    watch(
      () => props.siteId,
      (newVal) => {
        displayDevice(newVal);
      },
      { deep: true }
    );

    onMounted(() => {
      console.log('HEllo Prometheus');
      date.value = new Date(Date.now() - new Date().getTimezoneOffset() * 60000)
        .toISOString()
        .substr(0, 10);
      dateP.value = date.value;
      console.log(dateP);
      dateRange.value[0] = date.value;
      dateRange.value[1] = dateRange.value[0];
      dateRangeP.value = dateRange.value;
      dateRangeTextP.value = dateRangeP.value.join(' ~ ');
      dateRangeText.value = dateRange.value.join(' ~ ');
      getHistoryPrometheus();
    });
    return {
      dateRangeTextP,
      loopback1H,
      loopback2H,
      loopback3H,
      loopback0H,
      dateRangeP,
      messageP,
      historiesP,
      selectDateP,
      previousDayP,
      nextDayP,
      getHistoryPrometheus,
      PrometheusChartRef,
    };
  },
});
</script>

<style scoped></style>
