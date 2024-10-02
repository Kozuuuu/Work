<template>
  <q-page padding>
    <card-social
      title=""
      value=""
      percentage=""
      :prop_items="[]"
      :table-layout="'circuitDetails'"
      :date_timestamp="store.$state.providerCircuitsTodayCount.timeStamp"
    >
    </card-social>
    <card-social
      title="Store Connectivity 7 days"
      value=""
      percentage=""
      :prop_items="storeConnectivity7d"
      :table-layout="'circuitDetails'"
    >
    </card-social>
    <card-social
      title="Store Connectivity 24 hours"
      value=""
      percentage=""
      :prop_items="storeConnectivity24h"
      :table-layout="'circuitDetails'"
    >
    </card-social>
    <card-social
      title="Store Health Status 7 days"
      value=""
      percentage=""
      :prop_items="storeHealthStatus7d"
      :table-layout="'circuitDetails'"
    >
    </card-social>
    <card-social
      title="Store Health Status 24 hours"
      value=""
      percentage=""
      :prop_items="storeHealthStatus24h"
      :table-layout="'circuitDetails'"
    >
    </card-social>
    <q-card flat>
      <q-expansion-item
        icon="trending_up"
        label="Store Connectivity & Store Health Status Graph"
      >
        <q-separator />
        <q-select
          v-model="timeSelected"
          bordered
          :options="timeOptions"
          filled
          dense
          emit-value
          map-options
          style="width: 250px"
          class="q-ma-sm"
        />
        <div class="history-graph-cotainer">
          <iframe
            v-for="panelId in panelIds"
            :src="generateUrl(panelId)"
            frameborder="0"
          ></iframe>
        </div>
      </q-expansion-item>
    </q-card>
  </q-page>
</template>

<script setup lang="ts">
import { onMounted, ref } from "vue";
import CardSocial from "src/components/cards/CardSocial.vue";
import TableProviderCircuitReport from "src/components/tables/TableProviderCircuitReport.vue";
import { getProviderCircuitsToday, getCircuitReport } from "src/api/api";
import { IProviderCircuit, countTypes } from "src/api/types";
import { useSiteStore } from "src/stores/sites/stores";
import { useQuasar } from "quasar";

const providerCircuitData = ref([]);
const $q = useQuasar();
const store = useSiteStore();
const providerCircuitsToday = ref<countTypes[]>([]);
const storeConnectivity7d = ref<countTypes[]>([]);
const storeConnectivity24h = ref<countTypes[]>([]);
const storeHealthStatus7d = ref<countTypes[]>([]);
const storeHealthStatus24h = ref<countTypes[]>([]);
const theme = ref("light");
const toggleGraph = ref(false);

const setMindanaoCounts = async () => {
  // const count = await getProviderCircuitsToday();
  // store.$state.providerCircuitsTodayCount = count;

  // let dualCircuit = store.$state.providerCircuitsTodayCount.dualCircuit7D;
  // let primaryCircuit = store.$state.providerCircuitsTodayCount.primaryOnly7D;
  // let backupOnly = store.$state.providerCircuitsTodayCount.backupOnly7D;
  // let thirdOnly = store.$state.providerCircuitsTodayCount.thirdOnly7D;
  
  // const total = dualCircuit + primaryCircuit + backupOnly + thirdOnly;
  // const dualCircuit7D = (dualCircuit / total) * 100;
  // const primaryCircuit7D = (primaryCircuit / total) * 100;
  // const backupOnly7D = (backupOnly / total) * 100;
  // const thirdOnly7D = (thirdOnly / total) * 100;

  // const calc = (val: any) => {
  //   let formatted = store.$state.providerCircuitsTodayCount[`${val}`]

  //   const total = val + val + val + val;
  //   const calcVal = (val / total) * 100

  //   return calcVal
  // }

  const count = await getProviderCircuitsToday();
  store.$state.providerCircuitsTodayCount = count;

  type CircuitKeys = 'dualCircuit7D' | 'primaryOnly7D' | 'backupOnly7D' | 'thirdOnly7D' | 'dualCircuit24H' | 'primaryOnly24H' | 'backupOnly24H' | 'thirdOnly24H' | 'excellent7d' | 'problematic7d' | 'healthy7d' | 'excellent24h' | 'down7d' | 'problematic24h' | 'healthy24h' | 'down24h';

  const calc = (valKey: CircuitKeys) => {
    let val = store.$state.providerCircuitsTodayCount[valKey];

    const circuitKeys: CircuitKeys[] = ['dualCircuit7D', 'primaryOnly7D', 'backupOnly7D', 'thirdOnly7D'];

    const total = circuitKeys.reduce((acc, key) => {
      const circuitValue = store.$state.providerCircuitsTodayCount[key];
      if (typeof circuitValue === 'number') {
        acc += circuitValue;
      }
      return acc;
    }, 0);

    const calcVal = (val as number) / total * 100; // Ensure val is treated as a number

    return calcVal.toFixed(0);
  };

  // Example usage
// const dualCircuit7D = calc("dualCircuit7D").toFixed(2);
// const primaryCircuit7D = calc("primaryOnly7D").toFixed(2);
// const backupOnly7D = calc("backupOnly7D").toFixed(2);
// const thirdOnly7D = calc("down7d").toFixed(2);

//console.log(dualCircuit7D, primaryCircuit7D, backupOnly7D, thirdOnly7D);

  // providerCircuitsToday.value.push({
  //   title: "All Provider Circuits Today",
  //   value: store.$state.providerCircuitsTodayCount.providerCircuitsToday,
  //   bgColor: "#0077b6",
  //   bigSize: true,
  //   tableType: "provider_circuits_today",
  // });

  storeConnectivity7d.value.push({
    title: "Dual Circuit",
    value: store.$state.providerCircuitsTodayCount.dualCircuit7D,
    percentage: calc("dualCircuit7D"),
    bgColor: "bg-accent",
    tableType: "pct_dual_circuit_7d",
  });

  storeConnectivity7d.value.push({
    title: "Primary Only",
    value: store.$state.providerCircuitsTodayCount.primaryOnly7D,
    percentage: calc("primaryOnly7D"),
    bgColor: "bg-yellow-8",
    tableType: "pct_primary_only_7d",
  });

  storeConnectivity7d.value.push({
    title: "Backup Only",
    value: store.$state.providerCircuitsTodayCount.backupOnly7D,
    percentage: calc("backupOnly7D"),
    bgColor: "bg-warning",

    tableType: "pct_backup_only_7d",
  });
  storeConnectivity7d.value.push({
    title: "Third Up",
    value: store.$state.providerCircuitsTodayCount.thirdOnly7D,
    percentage: calc("thirdOnly7D"),
    bgColor: "bg-yellow-9",
    tableType: "third_only_7d",
  });
  storeConnectivity24h.value.push({
    title: "Dual Circuit",
    value: store.$state.providerCircuitsTodayCount.dualCircuit24H,
    percentage: calc("dualCircuit24H"),
    bgColor: "bg-accent",
    tableType: "pct_dual_circuit_24h",
  });

  storeConnectivity24h.value.push({
    title: "Primary Only",
    value: store.$state.providerCircuitsTodayCount.primaryOnly24H,
    percentage: calc("primaryOnly24H"),
    bgColor: "bg-yellow-8",
    tableType: "pct_primary_only_24h",
  });

  storeConnectivity24h.value.push({
    title: "Backup Only",
    value: store.$state.providerCircuitsTodayCount.backupOnly24H,
    percentage: calc("backupOnly24H"),
    bgColor: "bg-warning",

    tableType: "pct_backup_only_24h",
  });
  storeConnectivity24h.value.push({
    title: "Third Up",
    value: store.$state.providerCircuitsTodayCount.thirdOnly24H,
    percentage: calc("thirdOnly24H"),
    bgColor: "bg-yellow-9",

    tableType: "third_only_24h",
  });

  storeHealthStatus7d.value.push({
    title: "Excellent 100%",
    value: store.$state.providerCircuitsTodayCount.excellent7d,
    percentage: calc("excellent7d"),
    bgColor: "bg-accent",
    tableType: "pct_excellent_7d",
  });
  storeHealthStatus7d.value.push({
    title: "Up Healthy >= 95% But < 100%",
    value: store.$state.providerCircuitsTodayCount.healthy7d,
    percentage: calc("healthy7d"),
    bgColor: "bg-yellow-8",
    tableType: "pct_healthy_7d",
  });
  storeHealthStatus7d.value.push({
    title: "Up Problematic > 0% but 95%",
    value: store.$state.providerCircuitsTodayCount.problematic7d,
    percentage: calc("problematic7d"),
    bgColor: "bg-warning",
    tableType: "pct_problematic_7d",
  });
 

  storeHealthStatus24h.value.push({
    title: "Excellent 100%",
    value: store.$state.providerCircuitsTodayCount.excellent24h,
    percentage: calc("excellent24h"),
    bgColor: "bg-accent",
    tableType: "pct_excellent_24h",
  });
  storeHealthStatus7d.value.push({
    title: "Down 0%",
    value: store.$state.providerCircuitsTodayCount.down7d,
    percentage: calc("down7d"),
    bgColor: "bg-negative",

    tableType: "pct_down_7d",
  });
  storeHealthStatus24h.value.push({
    title: "Up Healthy >= 95% But < 100%",
    value: store.$state.providerCircuitsTodayCount.healthy24h,
    percentage: calc("healthy24h"),
    bgColor: "bg-yellow-8",
    tableType: "pct_healthy_24h",
  });
  storeHealthStatus24h.value.push({
    title: "Up Problematic > 0% but < 95%",
    value: store.$state.providerCircuitsTodayCount.problematic24h,
    percentage: calc("problematic24h"),
    bgColor: "bg-warning",
    tableType: "pct_problematic_24h",
  });
  storeHealthStatus24h.value.push({
    title: "Down 0%",
    value: store.$state.providerCircuitsTodayCount.down24h,
    percentage: calc("down24h"),
    bgColor: "bg-negative",

    tableType: "pct_down_24h",
  });
};

const panelIds = [12, 14];
const timeSelected = ref("15d");
const timeOptions = [
  { label: "Last 7 days", value: "7d" },
  { label: "Last 15 days", value: "15d" },
  { label: "Last 30 days", value: "1M" },
  { label: "Last 3 months", value: "3M" },
  { label: "Last 6 months", value: "6M" },
  { label: "Last 9 months", value: "9M" },
  { label: "Last 1 years", value: "1y" },
  { label: "Last 2 years", value: "2y" },
];
const generateUrl = (panelId: number) => {
  return `https://grafana.apolloglobal.net/d-solo/h2GD6-DIk/store-count-history?orgId=1&from=now-${timeSelected.value}&to=now&panelId=${panelId}&theme=${theme.value}`;
};

onMounted(async () => {
  $q.loading.show({
    message: "Gathering Mindanao Stores...",
  });
  try {
    await setMindanaoCounts();
  } catch (error) {
    console.log(error);
    $q.loading.hide();
  }
  $q.loading.hide();
});
</script>

<style lang="scss" scoped>
.history-graph-cotainer {
  max-width: 1800px;
  gap: 0.5em;
}

.history-graph-cotainer > iframe {
  width: 100%;
  min-width: 200px;
  /* max-width: 800px; */
  aspect-ratio: 16/7;
}

@media screen and (min-width: 850px) {
  .history-graph-cotainer {
    display: grid;
    grid-template-columns: 1fr 1fr;
  }
}
</style>
