<template>
  <q-page padding>
    <table-logs :get-logs-period="getLogsByPeriod" :get-all="loadDataTable" />
  </q-page>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import TableLogs from "src/components/tables/TableLogs.vue";
import { getWorkconnectLogs, getWorkconnectLogsPeriod } from "src/api/api";
import { rowsLog } from "src/api/types";
import { useSiteStore } from "src/stores/sites/stores";
import { storeToRefs } from "pinia";
import { useQuasar } from "quasar";

const $q = useQuasar();
const store = useSiteStore();
const { logDate, logsRows, logUsers } = storeToRefs(store);

const loadDataTable = async () => {
  logsRows.value = [];
  try {
    $q.loading.show({
      message: "Gathering Activity Logs...",
    });
    logsRows.value = await getWorkconnectLogs();
    console.log(logsRows.value);
    logUsers.value = [];
    const uniqueUsers = new Set(logsRows.value.map((entry) => entry.user));
    logUsers.value = [...uniqueUsers];
  } finally {
    $q.loading.hide();
  }
};
const getLogsByPeriod = async () => {
  try {
    $q.loading.show({
      message: "Gathering Activity Logs...",
    });
    const from = logDate.value.from.split("/").join("-");
    const to = logDate.value.to.split("/").join("-");
    logsRows.value = [];
    logsRows.value = await getWorkconnectLogsPeriod(from, to);
    logUsers.value = [];
    const uniqueUsers = new Set(logsRows.value.map((entry) => entry.user));
    logUsers.value = [...uniqueUsers];
    logDate.value.from = "";
    logDate.value.to = "";
  } finally {
    $q.loading.hide();
  }
};
</script>

<style scoped></style>
