<template>
  <q-table
    :title="`Cliqq Wifi Report`"
    :columns="columns"
    :rows="cliqqRow"
    :pagination="{
      rowsPerPage: 15,
      sortBy: 'sessionTime',
      descending: true,
    }"
    :filter="filter"
    :dense="fullScreen"
    :separator="separator"
    :loading="loading"
    class="q-py-sm"
    :no-data-label="noDataLabel"
  >
    <template v-slot:loading>
      <q-inner-loading
        showing
        color="primary"
        :label="`Gathering Cliqq wifi report ${dateRange.from} - ${dateRange.to}...`"
      />
    </template>

    <template #top-right="props">
      <q-input
        dense
        filled
        :model-value="`${dateRange.from} - ${dateRange.to}`"
        label="Select Time Period"
        readonly
      >
        <template v-slot:append>
          <q-icon name="event" class="cursor-pointer">
            <q-popup-proxy
              cover
              transition-show="scale"
              transition-hide="scale"
              ref="proxy"
            >
              <q-date v-model="dateRange" range @range-end="getCliqqRow">
                <div class="row items-center justify-end"></div>
              </q-date>
            </q-popup-proxy>
          </q-icon>
        </template> </q-input
    ></template>
  </q-table>
</template>

<script setup lang="ts">
import { QTableProps } from "quasar";
import { onMounted, ref, watch } from "vue";
import { getCliqqSummaryByStoreId } from "src/api/api";
import { IcliqqByStore } from "src/api/types";
import { secondsToMinutes, formatDate } from "src/utils/helper";
const props = defineProps<{
  storeId: string;
}>();

const dateRange = ref({ from: "", to: "" });
const loading = ref(false);
const fullScreen = ref(true);
const filter = ref("");
const separator = ref<"cell" | "horizontal" | "vertical">("horizontal");
const cliqqRow = ref<IcliqqByStore[]>([]);
const proxy = ref({ hide: () => {} });

const noDataLabel = ref("Please Select Time Period");
const columns = [
  {
    name: "startTime",
    align: "left",
    label: "Start Time",
    field: (row) => formatDate(row.startTime),
    sortable: true,
  },
  {
    name: "stopTime",
    align: "left",
    label: "Stop Time",
    field: (row) => formatDate(row.stopTime),
    sortable: true,
  },
  {
    name: "sessionTime",
    align: "left",
    label: "Session Time",
    field: (row) => secondsToMinutes(row.sessionTime),
    sortable: true,
  },
  {
    name: "terminateCause",
    align: "left",
    label: "Terminate Cause",
    field: "terminateCause",
    sortable: true,
  },
  {
    name: "callingStationId",
    align: "left",
    label: "Mac Address",
    field: "callingStationId",
    sortable: true,
  },
  {
    name: "inputoctets",
    align: "left",
    label: "Input Octets",
    field: "inputoctets",
    sortable: true,
  },
  {
    name: "outputoctets",
    align: "left",
    label: "Output Octets",
    field: "outputoctets",
    sortable: true,
  },
] as QTableProps["columns"];

const getCliqqRow = async () => {
  loading.value = true;
  const from = dateRange.value.from.split("/").join("-");
  const to = dateRange.value.to.split("/").join("-");
  proxy.value.hide();
  try {
    cliqqRow.value = await getCliqqSummaryByStoreId(from, to, props.storeId);
    if (cliqqRow.value.length === 0) {
      noDataLabel.value = `No Data Found for ${props.storeId} from ${from} to ${to}`;
    }
  } finally {
    loading.value = false;
  }
};

// watch( () => cliqqRow.value, () => {
//   if(cliqqRow.value.length === 0) {
//     noDataLabel.value = `No Data Found for ${props.storeId}`
//   }

// })
</script>

<style scoped></style>
