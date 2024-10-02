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

    <prometheus-compoenent
      :loopback0H="loopback0H"
      :loopback1H="loopback1H"
      :loopback2H="loopback2H"
      :loopback3H="loopback3H"
      :messageP="messageP"
      ref="PrometheusChart"
      class="mt-2"
    ></prometheus-compoenent>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from "vue";
import { useQuasar } from "quasar";
import { getHistoryPrometheusApi } from "../../api/testApi";
import { useSiteStore } from "../../stores/sites/sites";

import { useRoute } from "vue-router";

const route = useRoute();
const store = useSiteStore();
const dateRangeTextP = ref("");
const dateRangeP = ref(["", ""]);
const dateRange = ref(["", ""]);
const historiesP = ref([]);
const dateRangeText = ref("");
const messageP = ref("");
const loopback0H = ref([]);
const loopback1H = ref([]);
const loopback2H = ref([]);
const loopback3H = ref([]);
const DatePickerP = ref(false);
const dateP = ref("");
const tabsHistory = ref("Prometheus");
const historyHoursP = ref(1);
const PrometheusChart = ref();

const gettingHistoriesP = ref(false);
const selectedItem = ref(store.$state.site_id);
const serverTimeout = ref(false);
const date = ref("");
const $q = useQuasar();

function selectDateP() {
  const dateRangeProm = Object.values(dateRangeP.value);
  if (dateRangeProm.length > 0) {
    if (dateRangeProm.length === 1) dateRangeProm[1] = dateRangeProm[0];
    DatePickerP.value = false;
    // Convert the date strings to Date objects
    const date1 = new Date(dateRangeProm[0]);
    const date2 = new Date(dateRangeProm[1]);

    const diffInMilliseconds = date1.getTime() - date2.getTime();
    const diffInDays = Math.floor(diffInMilliseconds / (1000 * 60 * 60 * 24));

    if (diffInDays >= 0) {
      dateP.value = dateRangeProm[0].replaceAll("/", "-");
      historyHoursP.value = diffInDays + 1;
      dateRangeProm.reverse();
    } else {
      dateP.value = dateRangeProm[1].replaceAll("/", "-");
      historyHoursP.value = Math.abs(diffInDays) + 1;
    }
    getHistoryPrometheus();
  }
  dateRangeP.value = Object.assign({}, dateRangeProm);
}

function previousDayP() {
  let result = new Date(dateP.value);
  result.setDate(result.getDate() - 1);
  dateP.value = new Date(
    result.getTime() - new Date().getTimezoneOffset() * 60000
  )
    .toISOString()
    .slice(0, 10);
  result = new Date(dateRangeP.value[0]);
  result.setDate(result.getDate() - 1);
  dateRangeP.value[0] = new Date(
    result.getTime() - new Date().getTimezoneOffset() * 60000
  )
    .toISOString()
    .slice(0, 10);
  result = new Date(dateRangeP.value[1]);
  result.setDate(result.getDate() - 1);
  dateRangeP.value[1] = new Date(
    result.getTime() - new Date().getTimezoneOffset() * 60000
  )
    .toISOString()
    .slice(0, 10);
  getHistoryPrometheus();
}

function nextDayP() {
  var result = new Date(dateP.value);
  result.setDate(result.getDate() + 1);
  dateP.value = new Date(result - new Date().getTimezoneOffset() * 60000)
    .toISOString()
    .slice(0, 10);
  result = new Date(dateRangeP.value[0]);
  result.setDate(result.getDate() + 1);
  dateRangeP.value[0] = new Date(
    result - new Date().getTimezoneOffset() * 60000
  )
    .toISOString()
    .slice(0, 10);
  result = new Date(dateRangeP.value[1]);
  result.setDate(result.getDate() + 1);
  dateRangeP.value[1] = new Date(
    result - new Date().getTimezoneOffset() * 60000
  )
    .toISOString()
    .slice(0, 10);
  getHistoryPrometheus();
}

async function getHistoryPrometheus() {
  const dateRangeProm = Object.values(dateRangeP.value);
  dateRangeTextP.value = dateRangeProm.join(" ~ ").replaceAll("/", "-");
  // historiesP.value = [];

  gettingHistoriesP.value = true;
  if (tabsHistory.value === "Prometheus") {
    if (PrometheusChart.value) {
      const prometheusChartInstance = PrometheusChart.value;
      prometheusChartInstance.initializingHistory(selectedItem.value);
    }
  }

  try {
    historiesP.value = await getHistoryPrometheusApi(
      selectedItem.value,
      24 * historyHoursP.value,
      dateP.value
    );
    // console.table(historiesP.value);

    if (historiesP.value.error_message) {
      console.log("historiesP.value: ", historiesP.value);
      messageP.value = historiesP.value.error_message;
      $q.notify({
        type: "negative",
        message: "Error Getting Prometheus History",
      });
      historiesP.value = [];
    }
    store.$state.loopback0H = historiesP.value.filter((item: any) => {
      return item.loopback0 != null;
    });

    store.$state.loopback1H = historiesP.value.filter((item: any) => {
      return item.loopback1 != null;
    });
    store.$state.loopback2H = historiesP.value.filter((item: any) => {
      return item.loopback2 != null;
    });
    store.$state.loopback3H = historiesP.value.filter((item: any) => {
      return item.loopback3 != null;
    });
    // loopback0H.value = historiesP.value.filter((item: any) => {
    //   return item.loopback0 != null;
    // });

    // loopback1H.value = historiesP.value.filter((item: any) => {
    //   return item.loopback1 != null;
    // });
    // loopback2H.value = historiesP.value.filter((item: any) => {
    //   return item.loopback2 != null;
    // });
    // loopback3H.value = historiesP.value.filter((item: any) => {
    //   return item.loopback3 != null;
    // });
    console.log(
      loopback0H.value,
      loopback1H.value,
      loopback2H.value,
      loopback3H.value
    );
    if (tabsHistory.value === "Prometheus")
      if (PrometheusChart.value) {
        const prometheusChartInstance = PrometheusChart.value;
        prometheusChartInstance.initHistory(selectedItem.value);
      }

    gettingHistoriesP.value = false;
  } catch (error) {
    console.log(error);
    $q.notify({
      type: "negative",
      message: "Error Getting Prometheus History",
    });
    serverTimeout.value = true;
    gettingHistoriesP.value = false;
  }
}
async function displayDevice(item: string) {
  //selectedItem = item;
  getHistoryPrometheus();
}

watch(
  () => selectedItem.value,
  (newSiteId, oldSiteId) => {
    if (Array.isArray(newSiteId)) {
      // Handle the case where siteid is an array
      console.error(
        "siteid should be a single string, but it is an array:",
        newSiteId
      );
    } else {
      console.log("router");
      console.log("New Store ID: ", newSiteId);

      if (newSiteId !== "" && newSiteId !== undefined) {
        console.log("display");
        displayDevice(selectedItem.value);
      }
    }
  },
  { deep: true }
);

onMounted(() => {
  date.value = new Date(Date.now() - new Date().getTimezoneOffset() * 60000)
    .toISOString()
    .slice(0, 10);
  dateP.value = date.value;
  console.log(dateP.value);
  dateRange.value[0] = date.value;
  dateRange.value[1] = dateRange.value[0];
  dateRangeP.value = dateRange.value;
  dateRangeTextP.value = dateRangeP.value.join(" ~ ");
  dateRangeText.value = dateRange.value.join(" ~ ");

  displayDevice(selectedItem.value);
  // displayDevice(selectedItem);
  console.log(selectedItem.value);
});
</script>

<style scoped>
.q-icon:hover {
  background-color: whitesmoke;
  border-radius: 100%;
}
</style>
../../stores/sites/stores
