<template>
  <q-page padding>
    <card-social
      title="Mindanao"
      value=""
      percentage=""
      :prop_items="allMindanao"
      :table-layout="'circuitDetails'"
    >
    </card-social>
    <card-social
      title="Store Connectivity 7 days"
      value=""
      percentage=""
      :prop_items="storeConnectivity"
      :table-layout="'circuitDetails'"
    >
    </card-social>
    <card-social
      title="Store Health Status 7 days"
      value=""
      percentage=""
      :prop_items="storeHealthStatus"
      :table-layout="'circuitDetails'"
    >
    </card-social>
  </q-page>
</template>

<script setup lang="ts">
import { onMounted, ref } from "vue";
import CardSocial from "src/components/cards/CardSocial.vue";
import TableProviderCircuit from "src/components/tables/TableProviderCircuit.vue";
import { getMidanaoStoresCount } from "src/api/api";
import { IProviderCircuit, countTypes } from "src/api/types";
import { useSiteStore } from "src/stores/sites/stores";
import { useQuasar } from "quasar";

const $q = useQuasar();
const store = useSiteStore();
const allMindanao = ref<countTypes[]>([]);
const storeConnectivity = ref<countTypes[]>([]);
const storeHealthStatus = ref<countTypes[]>([]);
const setMindanaoCounts = async () => {
  const count = await getMidanaoStoresCount();
  store.$state.storeMindanaoCounts = count;

  type CircuitKeys = 'allMindanaoStores' | 'downMindanaoStores' | 'mindanaoDualCircuit' | 'mindanaoPrimaryOnly' | 'mindanaoBackupOnly' | 'mindanaoExcellent7D' | 'mindanaoProblematic7D' | 'mindanaoHealthyStore7D' | 'mindanaoDownStore7D';

  const calc = (valKey: CircuitKeys) => {
    let val = store.$state.storeMindanaoCounts[valKey];

    const circuitKeys: CircuitKeys[] = ['allMindanaoStores', 'downMindanaoStores'];

    const total = circuitKeys.reduce((acc, key) => {
      const circuitValue = store.$state.storeMindanaoCounts[key];
      if (typeof circuitValue === 'number') {
        acc += circuitValue;
      }
      return acc;
    }, 0);

    const calcVal = (val as number) / total * 100; // Ensure val is treated as a number

    return calcVal;
  };

  allMindanao.value.push({
    title: "All Mindanao Stores",
    value: store.$state.storeMindanaoCounts.allMindanaoStores,
    percentage: calc("allMindanaoStores").toFixed(2),
    bgColor: "bg-accent",
    bigSize: true,
    tableType: "mindanao_stores",
  });

  allMindanao.value.push({
    title: "Down Stores",
    value: store.$state.storeMindanaoCounts.downMindanaoStores,
    percentage: calc("downMindanaoStores").toFixed(2),
    bgColor: "bg-negative",
    tableType: "mindanao_down_stores",
  });
  storeConnectivity.value.push({
    title: "Dual Circuit",
    value: store.$state.storeMindanaoCounts.mindanaoDualCircuit,
    percentage: calc("mindanaoDualCircuit").toFixed(2),
    bgColor: "bg-accent",
    tableType: "mindanao_dual_circuit_7d",
  });

  storeConnectivity.value.push({
    title: "Primary Only",
    value: store.$state.storeMindanaoCounts.mindanaoPrimaryOnly,
    percentage: calc("mindanaoPrimaryOnly").toFixed(2),
    bgColor: "bg-yellow-8",

    tableType: "mindanao_primary_only_7d",
  });

  storeConnectivity.value.push({
    title: "Backup Only",
    value: store.$state.storeMindanaoCounts.mindanaoBackupOnly,
    percentage: calc("mindanaoBackupOnly").toFixed(2),
    bgColor: "bg-warning",
    tableType: "mindanao_backup_only_7d",
  });
  storeHealthStatus.value.push({
    title: "Excellent 100%",
    value: store.$state.storeMindanaoCounts.mindanaoExcellent7D,
    percentage: calc("mindanaoExcellent7D").toFixed(2),
    bgColor: "bg-accent",
    tableType: "mindanao_excellent_7d",
  });

  storeHealthStatus.value.push({
    title: "Up Problematic > 0% But < 95%",
    value: store.$state.storeMindanaoCounts.mindanaoProblematic7D,
    percentage: calc("mindanaoProblematic7D").toFixed(2),
    bgColor: "bg-yellow-8",
    tableType: "mindanao_problematic_7d",
  });
  storeHealthStatus.value.push({
    title: "Up Healthy >= 95% But < 100%",
    value: store.$state.storeMindanaoCounts.mindanaoHealthyStore7D,
    percentage: calc("mindanaoHealthyStore7D").toFixed(2),
    bgColor: "bg-warning",
    tableType: "mindanao_healthy_7d",
  });

  storeHealthStatus.value.push({
    title: "Down 0%",
    value: store.$state.storeMindanaoCounts.mindanaoDownStore7D,
    percentage: calc("mindanaoDownStore7D").toFixed(2),
    bgColor: "bg-negative",
    tableType: "mindanao_down_7d",
  });
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

<style lang="scss" scoped></style>
