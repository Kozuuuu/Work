<template>
  <q-page padding  :loading="loading">
    <div class = "top-props">
      <q-input
          filled
          v-model="input"
          dense
          readonly
          :label="timeLabel"
          class="children-props"
        >
          <template v-slot:append>
            <q-icon name="event" class="cursor-pointer">
              <q-popup-proxy
                cover
                transition-show="scale"
                transition-hide="scale"
                ref="proxy"
              >
                <q-date v-model="logDate" range @range-end="loadTable"> </q-date>
              </q-popup-proxy>
            </q-icon>
          </template>
        </q-input>
        <q-btn
          label="All Circuit Logs"
          @click="allLogs"
          outline
          class="children-props"
        ></q-btn>

    </div>

        <!-- <q-tab name="port1" label="Port 1"></q-tab> -->
        <q-tabs v-model="circuitLogTabs" dense class="text-dark" active-color="primary" indicator-color="primary"
      align="justify">
      <q-tab name="mac" label="Mac" />
      <q-tab name="provider" label="Provider"/>
      <q-tab name="imsi" label="IMSI"  />
    </q-tabs>


    <q-tab-panels v-model="circuitLogTabs">
      <q-tab-panel name="mac">
        <table-circuits-logs-mac :rows="rowCircuitsLogMac" :store-id="storeId" :ports="ports"
          :refresh="loadDataTableMac" />
      </q-tab-panel>
      <q-tab-panel name="provider">
        <table-circuits-logs-provider :rows="rowCircuitsLogProv" :store-id="storeId" :ports="ports"
          :refresh="loadDataTableProvider" />
      </q-tab-panel>
      <q-tab-panel name="imsi">
        <table-circuits-logs-i-m-s-i :rows="rowCircuitsLogImsi" :store-id="storeId" :ports="ports"
          :refresh="loadDataTableImsi" />
      </q-tab-panel>

    </q-tab-panels>

  </q-page>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";
import TableCircuitsLogs from "src/components/tables/TableCircuitsLogs.vue";
import TableCircuitsLogsMac from "src/components/tables/CircuitLogs/TableCircuitsLogsMac.vue";
import TableCircuitsLogsIMSI from "src/components/tables/CircuitLogs/TableCircuitsLogsIMSI.vue";
import TableCircuitsLogsProvider from "src/components/tables/CircuitLogs/TableCircuitsLogsProvider.vue";
import { getCircuitLogsBySiteId, getCircuitLogsMac, getCircuitLogsProvider, getCircuitLogsImsi, getCircuitsLogMacByTimePeriod, getCircuitsLogProvByTimePeriod, getCircuitsLogImsiByTimePeriod } from "src/api/api";
import { rowsCircuitsLog } from "src/api/types";
import { useSiteStore } from "src/stores/sites/stores";
import { storeToRefs } from "pinia";
const store = useSiteStore();
const { logDate } = storeToRefs(store);

const timeLabel = ref("Select Time Period");

const loading = ref(false);
const proxy = ref({ hide: () => { } });
const input = ref();

const filter = ref("");
const props = defineProps<{
  storeId: string;
  router?: string;
  getLogsPeriod?: () => void;
  getAll?: () => void;
}>();

const rowCircuitsLogMac = ref<rowsCircuitsLog[]>([]);
const rowCircuitsLogProv = ref<rowsCircuitsLog[]>([]);
const rowCircuitsLogImsi = ref<rowsCircuitsLog[]>([]);
const ports = ref<string[]>([]);
const circuitLogTabs = ref("mac");

const visibleColumns = ref([
  "user",
  "action",
  "service",
  "payload",
  "timestamp",
  "status",
]);


const getLogs = () => {
  const from = logDate.value.from;
  const to = logDate.value.to;
  input.value = `${from} to ${to}`;
  try {
    loading.value = true;
    props.getLogsPeriod?.();
    proxy.value.hide();
  } catch {
    console.log("No Data Found");
  } finally {
    loading.value = false;
  }
};

const loadTable = async ( ) => {
  rowCircuitsLogMac.value = [];
  rowCircuitsLogProv.value = [];
  rowCircuitsLogImsi.value = [];
  loadDataTableMac();
  loadDataTableProvider();
  loadDataTableImsi();

}

const allLogs = async() => {
  logDate.value.from = "";
  logDate.value.to = "";
  rowCircuitsLogMac.value = [];
  rowCircuitsLogProv.value = [];
  rowCircuitsLogImsi.value = [];
  loadDataTableMac();
  loadDataTableProvider();
  loadDataTableImsi();


}

const loadDataTableMac = async () => {
  console.log(logDate.value.from, logDate.value.to);
  if (logDate.value.from === "" || logDate.value.to === "") {
    rowCircuitsLogMac.value = await getCircuitLogsMac();
  }
  else {
    timeLabel.value = `${logDate.value.from} to ${logDate.value.to}`;
    rowCircuitsLogMac.value = await getCircuitsLogMacByTimePeriod(logDate.value.from.replace(/\//g, '-'), logDate.value.to.replace(/\//g, '-'));

  }

  const uniquePorts = new Set(rowCircuitsLogMac.value.map((entry) => entry.port));
  ports.value = [...uniquePorts];

};

const loadDataTableProvider = async () => {
  console.log(logDate.value.from, logDate.value.to);
  if (logDate.value.from === "" || logDate.value.to === "") {
    rowCircuitsLogProv.value = await getCircuitLogsProvider();
  }
  else {
    timeLabel.value = `${logDate.value.from} to ${logDate.value.to}`;
    rowCircuitsLogProv.value = await getCircuitsLogProvByTimePeriod(logDate.value.from.replace(/\//g, '-'), logDate.value.to.replace(/\//g, '-'));
  }
  const uniquePorts = new Set(rowCircuitsLogProv.value.map((entry) => entry.port));
  ports.value = [...uniquePorts];
};

const loadDataTableImsi = async () => {
  console.log(logDate.value.from, logDate.value.to);
  if (logDate.value.from === "" || logDate.value.to === "") {
    rowCircuitsLogImsi.value = await getCircuitLogsImsi();
  }
  else {
    timeLabel.value = `${logDate.value.from} to ${logDate.value.to}`;
    rowCircuitsLogImsi.value = await getCircuitsLogImsiByTimePeriod(logDate.value.from.replace(/\//g, '-'), logDate.value.to.replace(/\//g, '-'));
  }
  const uniquePorts = new Set(rowCircuitsLogProv.value.map((entry) => entry.port));
  ports.value = [...uniquePorts];
};

onMounted(() => {
  loadTable();
});
</script>

<style scoped>
.top-props {
  width: 100%;
  display: flex;
  flex-direction: row;
  flex: 1;
  gap: 1em;
  flex-wrap: wrap;
  padding: 1px 10px;
  margin: 10px 10px;
  justify-content: flex-end;
}
</style>

