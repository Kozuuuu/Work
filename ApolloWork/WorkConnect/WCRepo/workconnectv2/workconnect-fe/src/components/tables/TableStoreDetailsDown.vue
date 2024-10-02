<template>
  <q-table
    :columns="columns"
    :filter="filter"
    :rows="rows"
    :pagination="{
      rowsPerPage: 15,
    }"
    :dense="fullScreen"
    :separator="separator"
    :visible-columns="visibleColumns"
    :loading="rows.length === 0"
    class="q-py-sm"
  >
    <template #top-left>
      <div class="text-h6">
        {{ title }}
        <span v-if="cardTitle" class="text-caption">({{ cardTitle }})</span>
      </div>
    </template>
    <template #top-right="props">
      <div class="table-top-props">
        <q-btn v-if="refresh" @click="refresh" icon="refresh" round flat />
        <q-select
          v-model="visibleColumns"
          multiple
          filled
          dense
          options-dense
          :display-value="`Select Visible Columns`"
          emit-value
          map-options
          :options="columns"
          option-value="name"
          options-cover
          style="width: 200px"
        />

        <q-input
          v-if="(fullScreen = props.inFullscreen === true ? false : true)"
          v-model="filter"
          filled
          dense
          label="Search"
          debounce="300"
          color="primary"
          clearable
          style="width: 200px"
        >
          <template #append>
            <q-icon name="search" />
          </template>
        </q-input>

        <q-btn
          flat
          round
          dense
          :icon="mode === 'grid' ? 'list' : 'grid_on'"
          @click="
            mode = mode === 'grid' ? 'list' : 'grid';
            separator = mode === 'grid' ? 'cell' : 'horizontal';
          "
        >
          <q-tooltip>
            {{ mode === "grid" ? "Vertical" : "Grid" }}
          </q-tooltip>
        </q-btn>
        <q-btn
          v-show="hasPermission('ROLE_GENERATE_REPORTS')"
          flat
          round
          dense
          icon="upload_file"
          @click="exportTable"
          color="primary"
        >
          <q-tooltip>Export Table CSV</q-tooltip>
        </q-btn>
        <q-btn
          flat
          round
          dense
          :icon="props.inFullscreen ? 'fullscreen_exit' : 'fullscreen'"
          @click="props.toggleFullscreen"
        />
      </div>
      <q-btn
        v-if="fullScreen && closeBtn"
        icon="close"
        flat
        round
        class="table-close-btn"
        v-close-popup
      />
    </template>

    <template v-slot:body="props">
      <!-- <q-tr :props="props" @click="handleClick(props.row.site_id)">
        <q-td v-for="column in columnsField" :key="column" :props="props">
          {{ props.row[column] }}
        </q-td>
      </q-tr> -->
      <q-tr :props="props" @click="handleClick(props.row.site_id)">
        <q-td key="site_id" :props="props">
          {{ props.row.site_id }}
        </q-td>
        <q-td key="store_description" :props="props">
          {{ props.row.store_description }}
        </q-td>
        <q-td key="loopback_0" :props="props">
          {{ isNoData(props.row.loopback_0) }}
        </q-td>
        <q-td key="loopback_1" :props="props">
          {{ isNoData(props.row.loopback_1) }}
        </q-td>
        <q-td key="loopback_2" :props="props">
          {{ isNoData(props.row.loopback_2) }}
        </q-td>
        <q-td key="loopback_0_24h" :props="props">
          {{ isNoData(props.row.loopback_0_24h) }}
        </q-td>
        <q-td key="loopback_1_24h" :props="props">
          {{ isNoData(props.row.loopback_1_24h) }}
        </q-td>
        <q-td key="loopback_2_24h" :props="props">
          {{ isNoData(props.row.loopback_2_24h) }}
        </q-td>
        <q-td key="primary_provider" :props="props">
          {{ props.row.primary_provider }}
        </q-td>
        <!-- <q-td key="primary_circuit_status" :props="props">
          {{ props.row.primary_circuit_status }}
        </q-td> -->

        <q-td key="backup_provider" :props="props">
          {{ props.row.backup_provider }}
        </q-td>
        <q-td key="region" :props="props">
          {{ props.row.region }}
        </q-td>
        <q-td key="city" :props="props">
          {{ props.row.city }}
        </q-td>
        <q-td key="province" :props="props">
          {{ props.row.province }}
        </q-td>

        <!-- <q-td key="backup_circuit_status" :props="props">
          {{ props.row.backup_circuit_status }}
        </q-td> -->
      </q-tr>
    </template>
  </q-table>
  <!-- <q-btn label="Click me" color="primary" @click="inception = true" /> -->

  <q-dialog v-model="dashbordDetials" position="top">
    <q-card class="dialog-card">
      <q-card-section class="q-pa-none">
        <store-info></store-info>
      </q-card-section>
    </q-card>
  </q-dialog>
</template>

<script setup lang="ts">
import { toRefs, ref, onMounted } from "vue";
import { IdetailsListData, IProviderCircuit } from "src/api/types";
import { QTableProps } from "quasar";
import { useRouter, useRoute } from "vue-router";
import { useSiteStore } from "src/stores/sites/stores";
import StoreInfo from "src/components/storeInfo/StoreInfo.vue";
import { useQuasar, exportFile } from "quasar";
import { insertWorkconnectLog } from "src/api/api";
const $q = useQuasar();
const store = useSiteStore();
const route = useRoute();
const router = useRouter();
const props = defineProps<{
  rows: IdetailsListData[] | IProviderCircuit[];
  title: string;
  closeBtn: boolean;
  cardTitle?: string;
  refresh?: () => void;
}>();
const { closeBtn } = toRefs(props);
// const rows = [{}];

import { auth } from "src/stores/auth";
import { storeToRefs } from "pinia";

const auths = auth();
const {
  keycloak,
  getName,
}: {
  keycloak: any;
  getName: any;
} = storeToRefs(auths);
const hasPermission = (authority: String) => {
  if (keycloak.value.realmAccess.roles.includes(authority)) {
    console.log("keycloak", true);
    return true;
  }
  return false;
};

const filter = ref("");
const mode = ref("");
const fullScreen = ref(false);
const dashbordDetials = ref(false);
const separator = ref<"cell" | "horizontal">("horizontal");

const selectedSiteId = ref("");

const handleClick = (storeId: string) => {
  insertWorkconnectLog(`Visiting Store info for: ${storeId}`);

  if (route.path === "/Stores") {
    console.log(storeId);

    // router.push("/Stores/" + storeId);
    // router.push({ path: `/Stores/${storeId}` });
    router.push({ name: "Store Id", params: { storeId } });
  } else if (route.path === "/Dashboard") {
    store.$state.selectedStoreId = storeId;
    dashbordDetials.value = true;
  }
};

const visibleColumns = ref([
  "site_id",
  "store_description",
  "loopback_0",
  "loopback_1",
  "loopback_2",
  "loopback_0_24h",
  "loopback_1_24h",
  "loopback_2_24h",
  "primary_provider",
  // "primary_circuit_status",
  "backup_provider",
  // "backup_circuit_status",
]);

const columns = store.$state.storeSummaryColumn;

const isNoData = (value: number): string => {
  return value === -1 ? "NO DATA" : (Number(value) * 100).toFixed(0) + "%";
};

const wrapCsvValue = (val: any, formatFn?: Function | undefined, row?: any) => {
  let formatted = formatFn !== void 0 ? formatFn(val, row) : val;

  formatted =
    formatted === void 0 || formatted === null ? "" : String(formatted);

  formatted = formatted.split('"').join('""');
  // Excel accepts \n and \r in strings, but some other CSV parsers do not
  formatted = formatted.split("\n").join("\\n").split("\r").join("\\r");

  return `"${formatted}"`;
};

const exportTable = () => {
  const content = [(columns || []).map((col) => wrapCsvValue(col.label))]
    .concat(
      props.rows.map((row) =>
        (columns || [])
          .map((col) =>
            wrapCsvValue(
              typeof col.field === "function"
                ? col.field(row)
                : (row as any)[col.field === void 0 ? col.name : col.field],
              col.format,
              row
            )
          )
          .join(",")
      )
    )
    .join("\r\n");
  const fileName = props.cardTitle
    ? `${props.title}-${props.cardTitle}.csv`
    : `${props.title}.csv`;

  const status = exportFile(fileName, content, "text/csv");

  if (status !== true) {
    $q.notify({
      message: "Browser denied file download...",
      color: "negative",
      icon: "warning",
    });
  }
};
</script>

<style scoped>
.dialog-card {
  padding: 0;
  width: 100%;
  max-width: 1200px;
}
.table-top-props {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 00.5em;
  margin-right: 30px;
}
.table-close-btn {
  position: absolute;
  top: 0;
  right: 0;
  margin: 5px 5px 0 0;
}
</style>
