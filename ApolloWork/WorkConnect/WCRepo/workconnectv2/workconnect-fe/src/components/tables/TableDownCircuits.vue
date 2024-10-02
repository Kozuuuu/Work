<template>
  <q-separator /><q-table
    title="Down Circuits"
    :columns="column"
    :filter="filter"
    :rows="row"
    :loading="loading"
    :class="row.length > 0 ? 'my-sticky-virtscroll-table' : ''"
    separator="cell"
    :pagination="{
      rowsPerPage: row.length,
      sortBy: 'lastchange',
      descending: false,
    }"
    dense
    virtual-scroll
    :rows-per-page-options="[0]"
  >
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
    <template v-slot:top-right="props">
      <div class="row gap-1">
        <q-select
          label="Select Circuit Type"
          style="width: 200px"
          v-model="filter"
          :options="options"
          emit-value
          lab
          outlined
          map-options
          dense
          clearable
        ></q-select>
      </div>
    </template>
    <template v-slot:body="props">
      <q-tr
        :props="props"
        @click="handleClick(props.row.site_id)"
        class="clickable"
      >
        <q-td key="site_id" :props="props">
          {{ props.row.site_id }}
        </q-td>
        <q-td key="circuitType" :props="props">
          {{ props.row.circuitType }}
        </q-td>
        <q-td key="lastchange" :props="props">
          {{ timeDifference(props.row.lastchange) }}
        </q-td>
        <q-td key="provider" :props="props">
          {{ props.row.provider }}
        </q-td>
      </q-tr>
    </template>
  </q-table>
  <q-dialog v-model="dashbordDetials">
    <q-card class="dialog-card">
      <q-card-section class="q-pa-none">
        <store-info></store-info>
      </q-card-section>
    </q-card>
  </q-dialog>
</template>

<script setup lang="ts">
import { onMounted, ref } from "vue";
import { QTableProps } from "quasar";
import { DownCircuits } from "src/api/types";
import { getDownBackup, getDownPrimary } from "src/api/api";
import { timeDifference } from "src/utils/helper";
import { insertWorkconnectLog } from "src/api/api";
import StoreInfo from "../storeInfo/StoreInfo.vue";
import { useRoute, useRouter } from "vue-router";
import { useSiteStore } from "src/stores/sites/stores";
import { storeToRefs } from "pinia";

const options = [
  {
    value: "",
    label: "All",
  },
  {
    value: "Primary",
    label: "Primary",
  },
  {
    value: "Backup",
    label: "Backup",
  },
];

const loading = ref(false);
const store = useSiteStore();
const { downCircuits } = storeToRefs(store);
const dashbordDetials = ref(false);
const router = useRouter();
const route = useRoute();
const filter = ref("");
const row = ref<DownCircuits[]>([]);

const column = [
  {
    name: "site_id",
    align: "left",
    label: "Store ID",
    field: "site_id",
    sortable: true,
  },
  {
    name: "circuitType",
    align: "left",
    label: "Circuit Type",
    field: "circuitType",
  },
  {
    name: "lastchange",
    align: "left",
    label: "Down Duration",
    field: "lastchange",
    sortable: true,
  },
  {
    name: "provider",
    align: "left",
    label: "Provider",
    field: "provider",
    sortable: true,
  },
] as QTableProps["columns"];

const handleClick = (storeId: string) => {
  insertWorkconnectLog(`Visiting Store info for: ${storeId}`);
  store.$state.selectedStoreId = storeId;
  dashbordDetials.value = true;
};

onMounted(async () => {
  if (downCircuits.value.length === 0) {
    try {
      loading.value = true;
      const primary = await getDownPrimary();
      const backup = await getDownBackup();
      downCircuits.value = [...primary, ...backup];
      row.value = downCircuits.value;
    } finally {
      loading.value = false;
    }
  } else {
    row.value = downCircuits.value;
  }
});
</script>
<style scoped>
.dialog-card {
  padding: 0;
  width: 100%;
  max-width: 1200px;
}
</style>
