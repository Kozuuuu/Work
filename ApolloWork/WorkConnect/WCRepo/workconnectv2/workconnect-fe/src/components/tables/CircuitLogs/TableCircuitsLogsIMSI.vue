<template>
  <q-table style="height: 600px" :columns="columns" :rows="props.rows" dense
    class="q-py-sm my-sticky-virtscroll-table" row-key="user" virtual-scroll :filter="filter"
    v-model:pagination="pagination" :rows-per-page-options="[0]">
    <template #top-left="props">
      <!-- <q-select v-model="filter" filled dense label="Select Port" :options="ports" style="width: 250px"
        clearable class="q-pr-sm" />
      <q-input v-model="filter" filled dense label="Search" style="width: 250px" clearable /> -->
      <q-select v-model="filter" dense label="Select Port" :options="ports" style="width: 250px" clearable
        class="q-pr-sm" />
      <q-input  dense debounce="300" style="width: 250px" v-model="filter" placeholder="Search" clearable>
        <template v-slot:append>
          <q-icon name="search" />
        </template>
      </q-input>
    </template>
    <template #top-right="props">
      <q-btn @click="refresh" icon="refresh" round flat />
    </template>
    <template v-slot:header="props">
        <q-tr :props="props">
          <q-th
            v-for="col in props.cols"
            :key="col.name"
            :props="props"
            class="text-white bg-light-blue-10"
          >
            {{ col.label }}
          </q-th>
        </q-tr>
      </template>
    <template v-slot:body="props">
      <!-- <q-tr :props="props">
        <q-td key="user" :props="props">
          {{ props.row.user }}
        </q-td>
        <q-td key="action" :props="props">
          {{ props.row.action }}
        </q-td>
      </q-tr> -->
      <q-tr :props="props">
        <q-td key="timestamp" :props="props">
          {{ props.row.timestamp }}
        </q-td>
        <q-td key="router" :props="props">
          {{ props.row.router }}
        </q-td>
        <q-td key="siteID" :props="props">
          {{ props.row.siteID }}
        </q-td>
        <q-td key="port" :props="props">
          {{ props.row.port }}
        </q-td>
        <q-td key="previous" :props="props">
          {{ props.row.previous }}
        </q-td>
        <q-td key="IMSI" :props="props">
          {{ props.row.imsi }}
        </q-td>
        <q-td key="macStatus" :props="props">
          <q-badge :color="getBadgeColor(props.row.macStatus)">
            {{ props.row.macStatus }}
          </q-badge>
        </q-td>
        <!-- <q-td key="mac1" :props="props">
          {{ props.row.mac1 }}
        </q-td>
        <q-td key="mac1Status" :props="props">
          {{ props.row.mac1Status }}
        </q-td>
        <q-td key="mac2" :props="props">
          {{ props.row.mac2 }}
        </q-td>
        <q-td key="mac2Status" :props="props">
          {{ props.row.mac2Status }}
        </q-td>
        <q-td key="IMSI" :props="props">
          {{ props.row.IMSI }}
        </q-td>
        <q-td key="IMSIStatus" :props="props">
          {{ props.row.IMSIStatus }}
        </q-td>
        <q-td key="provider1" :props="props">
          {{ props.row.provider1 }}
        </q-td>
        <q-td key="provider1Status" :props="props">
          {{ props.row.provider1Status }}
        </q-td>
        <q-td key="provider2" :props="props">
          {{ props.row.provider2 }}
        </q-td>
        <q-td key="provider2Status" :props="props">
          {{ props.row.provider2Status }}
        </q-td>
        <q-td key="providerCellular" :props="props">
          {{ props.row.providerCellular }}
        </q-td>
        <q-td key="providerCellularStatus" :props="props">
          {{ props.row.providerCellularStatus }}
        </q-td>
        <q-td key="publicIp1" :props="props">
          {{ props.row.publicIp1 }}
        </q-td>
        <q-td key="publicIp2" :props="props">
          {{ props.row.publicIp2 }}
        </q-td>
        <q-td key="publicIpCellular" :props="props">
          {{ props.row.publicIpCellular }}
        </q-td> -->
      </q-tr>
    </template>
  </q-table>
</template>

<script setup lang="ts">
import { ref } from "vue";
import { QTableProps } from "quasar";

import moment from "moment-timezone";
import { rowsCircuitsLog } from "src/api/types";


const props = defineProps<{
  rows: rowsCircuitsLog[];
  ports?: string[];
  refresh: () => void;
}>();
const filter = ref("");
const pagination = ref({
  rowsPerPage: props.rows.length,
  sortBy: "timestamp",
  descending: true,
});
const columns = [
  {
    name: "timestamp",
    align: "left",
    label: "Timestamp",
    field: "timestamp",
    sortable: true,
  },
  {
    name: "router",
    align: "left",
    label: "Router",
    field: "router",
    sortable: true,
  },
  {
    name: "siteID",
    align: "left",
    label: "Site ID",
    field: "siteID",
    sortable: true,
  },
  {
    name: "port",
    align: "left",
    label: "Port",
    field: "port",
    sortable: true,
  },
  {
    name: "previous",
    align: "left",
    label: "Previous",
    field: "previous",
    sortable: true,
  },
  {
    name: "IMSI",
    align: "left",
    label: "IMSI",
    field: "imsi",
    sortable: true,
  },
  {
    name: "macStatus",
    align: "left",
    label: "Mac Status",
    field: "Status",
    sortable: true,
  },
  // {
  //   name: "mac1",
  //   align: "left",
  //   label: "Mac Primary",
  //   field: "mac1",
  //   sortable: true,
  // },
  // {
  //   name: "mac1Status",
  //   align: "left",
  //   label: "Mac Primary Status",
  //   field: "mac1Status",
  //   sortable: true,
  // },
  // {
  //   name: "mac2",
  //   align: "left",
  //   label: "Mac Backup",
  //   field: "mac2",
  //   sortable: true,
  // },
  // {
  //   name: "mac2Status",
  //   align: "left",
  //   label: "Mac Backup Status",
  //   field: "mac2Status",
  //   sortable: true,
  // },
  // {
  //   name: "IMSI",
  //   align: "left",
  //   label: "IMSI",
  //   field: "IMSI",
  //   sortable: true,
  // },
  // {
  //   name: "IMSIStatus",
  //   align: "left",
  //   label: "IMSI Status",
  //   field: "IMSIStatus",
  //   sortable: true,
  // },
  // {
  //   name: "provider1",
  //   align: "left",
  //   label: "Provider Primary",
  //   field: "provider1",
  //   sortable: true,
  // },
  // {
  //   name: "provider1Status",
  //   align: "left",
  //   label: "Prov. Primary Status",
  //   field: "provider1Status",
  //   sortable: true,
  // },
  // {
  //   name: "provider2",
  //   align: "left",
  //   label: "Provider Backup",
  //   field: "provider2",
  //   sortable: true,
  // },
  // {
  //   name: "provider2Status",
  //   align: "left",
  //   label: "Prov. Backup Status",
  //   field: "provider2Status",
  //   sortable: true,
  // },
  // {
  //   name: "providerCellular",
  //   align: "left",
  //   label: "Provider Cellular",
  //   field: "providerCellular",
  //   sortable: true,
  // },
  // {
  //   name: "providerCellularStatus",
  //   align: "left",
  //   label: "Prov. Cell Status",
  //   field: "providerCellularStatus",
  //   sortable: true,
  // },
  // {
  //   name: "publicIp1",
  //   align: "left",
  //   label: "Public IP Primary",
  //   field: "publicIp1",
  //   sortable: true,
  // },
  // {
  //   name: "publicIp2",
  //   align: "left",
  //   label: "Public IP Backup",
  //   field: "publicIp2",
  //   sortable: true,
  // },
  // {
  //   name: "publicIpCellular",
  //   align: "left",
  //   label: "Public IP Cellular",
  //   field: "publicIpCellular",
  //   sortable: true,
  // },
] as QTableProps["columns"];


const truncateArray = (stringArray: string[]): string => {
  const maxItems = 3;
  if (stringArray.length <= 3) {
    return stringArray.join(", ");
  } else {
    const truncated = stringArray.slice(0, maxItems);
    return `${truncated.join(", ")} + ${stringArray.length - maxItems} ...`;
  }
};

const getBadgeColor = (macStatus: string) => {
  switch (macStatus) {
    case 'added':
      return 'green';
    case 'removed':
      return 'red';
    case 'changed':
      return 'orange';
    default:
      return 'blue'; // You can set a default color or handle other cases as needed
  }
};

</script>

<style scoped>
td {
  max-width: 300px;
  /* white-space: pre-wrap; */
}
</style>
