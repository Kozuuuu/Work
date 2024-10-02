<template>
    <q-page padding>
        <!-- <q-tab name="port1" label="Port 1"></q-tab> -->
        <q-tabs v-model="circuitLogTabs" dense class="text-dark" active-color="primary" indicator-color="primary"
            align="justify">
            <q-tab name="mac" label="Mac"  @click="loadDataTableMac"/>
            <q-tab name="provider" label="Provider"  @click="loadDataTableProvider" />
            <q-tab v-if="props.router === 'RUIJIE'" name="imsi" label="IMSI"   @click="loadDataTableImsi"/>
        </q-tabs>

        <q-tab-panels v-model="circuitLogTabs">
            <q-tab-panel name="mac">
                <table-circuits-logs-mac :rows="rowsCircuitsLogs" :store-id="storeId" :ports="ports" :refresh="loadDataTableMac" />
            </q-tab-panel>
            <q-tab-panel name="provider">
                <table-circuits-logs-provider :rows="rowsCircuitsLogs" :store-id="storeId" :ports="ports" :refresh="loadDataTableProvider" />
            </q-tab-panel>
            <q-tab-panel name="imsi" v-if="props.router === 'RUIJIE'">
                <table-circuits-logs-i-m-s-i :rows="rowsCircuitsLogs" :store-id="storeId" :ports="ports" :refresh="loadDataTableImsi" />
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
import { getCircuitLogsBySiteId, getCircuitLogsMacBySiteId, getCircuitLogsProviderBySiteId, getCircuitLogsImsiBySiteId } from "src/api/api";
import { rowsCircuitsLog } from "src/api/types";


const filter = ref("");
const props = defineProps<{
    storeId: string;
    router ?: string;
}>();

const rowsCircuitsLogs = ref<rowsCircuitsLog[]>([]);
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

const loadDataTableMac = async () => {
    rowsCircuitsLogs.value = await getCircuitLogsMacBySiteId(props.storeId);
    const uniquePorts = new Set(rowsCircuitsLogs.value.map((entry) => entry.port));
    ports.value = [...uniquePorts];
};

const loadDataTableProvider = async () => {
    rowsCircuitsLogs.value = await getCircuitLogsProviderBySiteId(props.storeId);
    const uniquePorts = new Set(rowsCircuitsLogs.value.map((entry) => entry.port));
    ports.value = [...uniquePorts];
};

const loadDataTableImsi = async () => {
    rowsCircuitsLogs.value = await getCircuitLogsImsiBySiteId(props.storeId);
    const uniquePorts = new Set(rowsCircuitsLogs.value.map((entry) => entry.port));
    ports.value = [...uniquePorts];
};

onMounted(() => {
    loadDataTableMac();
});
</script>
  
<style scoped></style>
  