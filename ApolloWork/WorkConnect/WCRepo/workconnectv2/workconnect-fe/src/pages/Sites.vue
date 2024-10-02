<template>
  <q-page>
    <router-view></router-view>

    <div v-if="route.name === 'Stores'" class="q-pa-md">
      <!-- <q-btn @click="refreshTable">Refresh</q-btn> -->
      <!-- <table-store-details
        title="Store Summary"
        :rows="rows"
        :close-btn="false"
        :refresh="refreshTable"
      ></table-store-details> -->
      <table-provider-circuit
        title="Store Summary Circuits"
        :rows="rowsCircuit"
        :close-btn="false"
        :refresh="refreshTable"
        :loopback-val="'uptime'"
      >
      </table-provider-circuit>
    </div>
  </q-page>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import { QTableProps } from "quasar";
import {
  getAllStoreData,
  getStoreProfile,
  getStoreProfileAdditional,
  getDetailsList,
  getZabbixCircuitReport,
} from "src/api/api";
import {
  IstoreProfile,
  IdetailsListData,
  IProviderCircuit,
} from "src/api/types";
import { getLoopbackStatus } from "src/api/testApi";
import { useSiteStore } from "src/stores/sites/stores";
import TableStoreDetails from "src/components/tables/TableStoreDetails.vue";
import TableProviderCircuit from "src/components/tables/TableProviderCircuit.vue";
import { useRouter, useRoute } from "vue-router";
import { useQuasar } from "quasar";
import TableZabbix from "src/components/tables/TableZabbix.vue";

const $q = useQuasar();
const store = useSiteStore();
const router = useRouter();
const route = useRoute();

const searchStoreId = ref("");
const showTable = ref(false);

const rows = ref<IdetailsListData[]>([]);
const rowsCircuit = ref<IProviderCircuit[]>([]);

const refreshTable = async () => {
  rowsCircuit.value = [];
  store.$state.storeSummaryRow = await getDetailsList(
    "provider_circuits_today"
  );
  rowsCircuit.value = store.$state.storeSummaryRow;
};

onMounted(async () => {
  if (store.$state.storeSummaryRow.length === 0) {
    store.$state.storeSummaryRow = await getDetailsList(
      "provider_circuits_today"
    );
    rowsCircuit.value = store.$state.storeSummaryRow;
    // rows.value = store.$state.storeSummaryRow;
  } else {
    rowsCircuit.value = store.$state.storeSummaryRow;
  }
});
</script>

<style scoped>
.q-tr:hover {
  background-color: rgb(25, 28, 36, 0.1);
  cursor: pointer;
}
.q-tr:active {
  color: red;
}
</style>
