<template>
  <div>
    <div class="row">
      <q-input v-model="dateRangeText" label="Date" readonly class="mx-5">
        <template #prepend>
          <q-icon name="event" class="cursor-pointer"></q-icon>
          <q-popup-proxy
            ref="qDateProxy"
            cover
            transition-show="scale"
            transition-hide="scale"
          >
            <q-date v-model="dateRange" minimal range>
              <q-space></q-space>
              <div align="right">
                <q-btn flat text label="Cancel" color="primary" v-close-popup>
                </q-btn>
                <q-btn
                  flat
                  text
                  label="OK"
                  color="primary"
                  @click="selectDate()"
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
            @click="previousDay()"
          ></q-icon>
          <q-icon
            name="arrow_forward"
            class="cursor-pointer"
            @click="nextDay()"
          ></q-icon>
        </template>
      </q-input>
    </div>
    <div
      v-if="historiesP.length === 0 && historiesP"
      class="text-grey-5"
      align="center"
    >
      {{ message }}
    </div>
    <Snmp
      :TrafficIn="TrafficIn"
      :TrafficOut="TrafficOut"
      :message="message"
      ref="SNMP"
    />
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, watch, onMounted } from 'vue';
import { useQuasar } from 'quasar';
import {
  getTrafficInPrometheus,
  getTrafficOutPrometheus,
} from 'src/api/testApi';
import Snmp from 'src/components/snmp/index.vue';
export default defineComponent({
  components: {
    Snmp,
  },
  props: ['siteId'],
  setup(props) {
    const $q = useQuasar();
    const dateRangeTextP = ref('');
    const dateRangeText = ref('');
    const dateRange = ref(['', '']);
    const historiesP = ref([]);
    const message = ref('');
    const TrafficIn = ref([]);
    const TrafficOut = ref([]);
    const selectedItem = props.siteId;
    const date = ref('');
    const SNMP = ref(null);
    const gettingTraffic = ref(false);
    const tabsHistory = ref('SNMP');
    const trafficError = ref(false);
    const historyHours = ref(1);
    const serverTimeout = ref(false);
    const dateRangeP = ref(['', '']);
    const dateP = ref('');
    const DatePicker = ref(false);

    console.log(selectedItem);

    function previousDay() {
      var result = new Date(date.value);
      result.setDate(result.getDate() - 1);
      date.value = new Date(result - new Date().getTimezoneOffset() * 60000)
        .toISOString()
        .substr(0, 10);
      console.log('dateRange.value: ', dateRange.value);
      result = new Date(dateRange.value[0]);
      result.setDate(result.getDate() - 1);
      dateRange.value[0] = new Date(
        result - new Date().getTimezoneOffset() * 60000
      )
        .toISOString()
        .substr(0, 10);
      result = new Date(dateRange.value[1]);
      result.setDate(result.getDate() - 1);
      dateRange.value[1] = new Date(
        result - new Date().getTimezoneOffset() * 60000
      )
        .toISOString()
        .substr(0, 10);
      getTrafficPrometheus();
      console.log(date.value);
    }

    function nextDay() {
      var result = new Date(date.value);
      result.setDate(result.getDate() + 1);
      date.value = new Date(result - new Date().getTimezoneOffset() * 60000)
        .toISOString()
        .substr(0, 10);
      result = new Date(dateRange.value[0]);
      result.setDate(result.getDate() + 1);
      dateRange.value[0] = new Date(
        result - new Date().getTimezoneOffset() * 60000
      )
        .toISOString()
        .substr(0, 10);
      result = new Date(dateRange.value[1]);
      result.setDate(result.getDate() + 1);
      dateRange.value[1] = new Date(
        result - new Date().getTimezoneOffset() * 60000
      )
        .toISOString()
        .substr(0, 10);
      getTrafficPrometheus();
      console.log(date.value);
    }
    function selectDate() {
      const dateRangeSNMP = Object.values(dateRange.value);
      if (dateRangeSNMP.length > 0) {
        if (dateRangeSNMP.length == 1) dateRangeSNMP[1] = dateRangeSNMP[0];
        DatePicker.value = false;
        const diffInDays =
          (new Date(dateRangeSNMP[0]) - new Date(dateRangeSNMP[1])) / 86400000;
        if (diffInDays >= 0) {
          date.value = dateRangeSNMP[0].replaceAll('/', '-');
          console.log('date.value: ', date.value);
          historyHours.value = diffInDays + 1;
          console.log('dateRangeSNMP: ', dateRangeSNMP);
          dateRangeSNMP.reverse();
        } else {
          date.value = dateRangeSNMP[1].replaceAll('/', '-');
          console.log('date.value: ', date.value);
          historyHours.value = diffInDays * -1 + 1;
        }
        getTrafficPrometheus();
      }
      dateRange.value = Object.assign({}, dateRangeSNMP);
    }

    async function getTrafficPrometheus() {
      const dateRangeSNMP = Object.values(dateRange.value);
      dateRangeText.value = dateRangeSNMP.join(' ~ ').replaceAll('/', '-');
      TrafficIn.value = [];
      TrafficOut.value = [];
      gettingTraffic.value = true;
      if (tabsHistory.value === 'SNMP')
        SNMP.value.initializingTraffic(selectedItem);
      getTrafficPrometheusIn();
      getTrafficPrometheusOut();
    }

    async function getTrafficPrometheusIn() {
      try {
        console.log('HASHEM');
        console.log('getting traffic');
        trafficError.value = false;
        TrafficIn.value = await getTrafficInPrometheus(
          selectedItem,
          24 * historyHours.value,
          5,
          date.value
        );
        console.log('TrafficIn.value: ', TrafficIn.value);
        if (TrafficIn.value.error_message) {
          message.value = TrafficIn.value.error_message;
          TrafficIn.value = [];
          TrafficOut.value = [];
        }
        if (
          TrafficIn.value.length == TrafficOut.value.length ||
          (TrafficIn.value.length && TrafficOut.value.length)
        ) {
          console.log('in first');
          if (tabsHistory.value === 'SNMP')
            SNMP.value.initTraffic(selectedItem);
          gettingTraffic.value = false;
        }
      } catch (e) {
        console.log(e);
        $q.notify({
          type: 'negative',
          message: 'Error Getting SNMP Data',
        });
        serverTimeout.value = true;
        gettingTraffic.value = false;
        trafficError.value = true;
      }
    }

    async function getTrafficPrometheusOut() {
      try {
        console.log('getting traffic');
        trafficError.value = false;
        TrafficOut.value = await getTrafficOutPrometheus(
          selectedItem,
          24 * historyHours.value,
          5,
          date.value
        );
        if (TrafficOut.value.error_message) {
          message.value = TrafficOut.value.error_message;
          TrafficIn.value = [];
          TrafficOut.value = [];
        }
        if (
          TrafficIn.value.length == TrafficOut.value.length ||
          (TrafficIn.value.length && TrafficOut.value.length)
        ) {
          console.log('out first');
          console.log(TrafficIn);
          console.log(TrafficOut);
          if (tabsHistory.value === 'SNMP')
            SNMP.value.initTraffic(selectedItem);
          gettingTraffic.value = false;
        }
      } catch (e) {
        console.log(e);
        $q.notify({
          type: 'negative',
          message: 'Error Getting SNMP Data',
        });
        serverTimeout.value = true;
        gettingTraffic.value = false;
        trafficError.value = true;
      }
    }
    async function displayDevice(siteId: string) {
      getTrafficPrometheus();
    }
    watch(
      () => props.siteId,
      (newVal) => {
        displayDevice(newVal);
      },
      { deep: true }
    );

    onMounted(() => {
      date.value = new Date(Date.now() - new Date().getTimezoneOffset() * 60000)
        .toISOString()
        .slice(0, 10);
      dateP.value = date.value;
      console.log(dateP);
      dateRange.value[0] = date.value;
      dateRange.value[1] = dateRange.value[0];
      dateRangeP.value = dateRange.value;
      dateRangeTextP.value = dateRangeP.value.join(' ~ ');
      dateRangeText.value = dateRange.value.join(' ~ ');
      displayDevice(selectedItem);
      getTrafficPrometheus();
    });
    return {
      dateRangeTextP,
      dateRangeText,
      dateRange,
      historiesP,
      message,
      TrafficIn,
      TrafficOut,
      date,
      previousDay,
      nextDay,
      getTrafficPrometheus,
      gettingTraffic,
      tabsHistory,
      SNMP,
      trafficError,
      historyHours,
      serverTimeout,
      dateRangeP,
      dateP,
      DatePicker,
      selectDate,
      getTrafficPrometheusIn,
      getTrafficPrometheusOut,
      displayDevice,
    };
  },
});
</script>

<style scoped></style>
