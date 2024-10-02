<template>
  <q-table
    :columns="columns"
    :rows="props.rows"
    :pagination="{
      rowsPerPage: 20,
      sortBy: 'loopback_0',
      descending: false,
    }"
    :filter="filter"
    :dense="fullScreen"
    :separator="separator"
    :visible-columns="visibleColumns"
    :loading="rows.length === 0"
    class="q-py-sm my-sticky-first-column-table"
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
          v-show="hasPermission(['ROLE_GENERATE_REPORTS'])"
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
        <q-btn
          v-if="fullScreen && closeBtn"
          icon="close"
          flat
          round
          class="table-close-btn"
          v-close-popup
        />
      </div>
    </template>

    <template v-slot:body="props">
      <!-- <q-tr :props="props" @click="handleClick(props.row.site_id)">
        <q-td v-for="column in columnsField" :key="column" :props="props">
          {{ props.row[column] }}
        </q-td>
      </q-tr> -->
      <q-tr
        :props="props"
        @click="handleClick(props.row.site_id)"
        class="clickable"
      >
        <q-td key="site_id" :props="props">
          {{ props.row.site_id }}
        </q-td>
        <q-td key="router" :props="props">
          {{ props.row.router }}
        </q-td>
        <q-td key="loopback_0" :props="props">
          {{
            loopbackVal === "duration"
              ? uptimeToDuration7D(props.row.loopback_0)
              : isNoData(props.row.loopback_0)
          }}
        </q-td>
        <q-td key="loopback_1" :props="props">
          {{
            loopbackVal === "duration"
              ? uptimeToDuration7D(props.row.loopback_1)
              : isNoData(props.row.loopback_1)
          }}
        </q-td>
        <q-td key="loopback_2" :props="props">
          {{
            loopbackVal === "duration"
              ? uptimeToDuration7D(props.row.loopback_2)
              : isNoData(props.row.loopback_2)
          }}
        </q-td>
        <!-- <q-td key="loopback_3" :props="props">
          {{ isNoData(props.row.loopback_3) }}
        </q-td> -->
        <q-td key="loopback_0_24h" :props="props">
          {{
            loopbackVal === "duration"
              ? uptimeToDuration24H(props.row.loopback_0_24h)
              : isNoData(props.row.loopback_0_24h)
          }}
        </q-td>
        <q-td key="loopback_1_24h" :props="props">
          {{
            loopbackVal === "duration"
              ? uptimeToDuration24H(props.row.loopback_1_24h)
              : isNoData(props.row.loopback_1_24h)
          }}
        </q-td>
        <q-td key="loopback_2_24h" :props="props">
          {{
            loopbackVal === "duration"
              ? uptimeToDuration24H(props.row.loopback_2_24h)
              : isNoData(props.row.loopback_2_24h)
          }}
        </q-td>
        <!-- <q-td key="loopback_3_24h" :props="props">
          {{ loopbackVal === 'duration' ? isNoData(props.row.loopback_3_24h) }}
        </q-td> -->

        <q-td key="provider_primary" :props="props">
          {{ props.row.provider_primary }}
        </q-td>

        <q-td key="provider_backup" :props="props">
          {{ props.row.provider_backup }}
        </q-td>
        <q-td key="provider_third" :props="props">
          {{ props.row.provider_third }}
        </q-td>
        <q-td key="mac_primary" :props="props">
          {{ props.row.mac_primary }} </q-td
        ><q-td key="mac_backup" :props="props">
          {{ props.row.mac_backup }}
        </q-td>
        <q-td key="mac_third" :props="props">
          {{ props.row.mac_third }}
        </q-td>
        <q-td key="gtw_primary" :props="props">
          {{ props.row.gtw_primary }}
        </q-td>
        <q-td key="gtw_backup" :props="props">
          {{ props.row.gtw_backup }}
        </q-td>
        <q-td key="gtw_third" :props="props">
          {{ props.row.gtw_third }}
        </q-td>

        <q-td key="public_ip_primary" :props="props">
          {{ props.row.public_ip_primary }}
        </q-td>
        <q-td key="public_ip_backup" :props="props">
          {{ props.row.public_ip_backup }}
        </q-td>
        <q-td key="public_ip_third" :props="props">
          {{ props.row.public_ip_third }}
        </q-td>
        <q-td key="serial_number" :props="props">
          {{ props.row.serial_number }}
        </q-td>
      </q-tr>
    </template>
  </q-table>
  <q-dialog v-model="dashbordDetials" position="top">
    <q-card class="dialog-card">
      <q-card-section class="q-pa-none">
        <store-info></store-info>
      </q-card-section>
    </q-card>
  </q-dialog>
</template>

<script setup lang="ts">
import { onMounted, ref } from "vue";
import { useSiteStore } from "src/stores/sites/stores";
import { useRouter, useRoute } from "vue-router";
import StoreInfo from "../storeInfo/StoreInfo.vue";
import { IProviderCircuit, IdetailsListData } from "src/api/types";
import { useQuasar, exportFile, QTableProps, QTableColumn } from "quasar";
import {
  uptimeToDuration7D,
  uptimeToDuration24H,
  isNoData,
} from "src/utils/helper";
import { insertWorkconnectLog } from "src/api/api";
import { hasPermission } from "src/utils/helper";
const props = defineProps<{
  rows: IProviderCircuit[] | IdetailsListData[];
  title: string;
  closeBtn: boolean;
  cardTitle?: string;
  refresh?: () => void;
  loopbackVal: "uptime" | "duration";
}>();

const $q = useQuasar();
const store = useSiteStore();

const fullScreen = ref(false);
const filter = ref("");
const separator = ref<"cell" | "horizontal">("horizontal");
const mode = ref("");
const columns = ref<QTableProps["columns"]>([]);
const route = useRoute();
const router = useRouter();
const dashbordDetials = ref(false);
const visibleColumns = ref([
  "site_id",
  "router",
  "loopback_0",
  "loopback_1",
  "loopback_2",
  "loopback_0_24h",
  "loopback_1_24h",
  "loopback_2_24h",
  "mac_primary",
  "mac_backup",
  "gtw_primary",
  "gtw_backup",
  "public_ip_primary",
  "public_ip_backup",
  "provider_primary",
  "provider_backup",
  "region",
  "city",
  "province",
  "serial_number",
]);

const handleClick = (storeId: string) => {
  insertWorkconnectLog(`Visiting Store info for: ${storeId}`);

  if (route.path === "/Stores") {
    console.log(storeId);

    router.push({ name: "Store Id", params: { storeId } });
  } else if (route.path === "/Dashboard") {
    store.$state.selectedStoreId = storeId;
    dashbordDetials.value = true;
  } else {
    store.$state.selectedStoreId = storeId;
    dashbordDetials.value = true;
  }
};

// import { auth } from "src/stores/auth";
// import { storeToRefs } from "pinia";

// const auths = auth();
// const {
//   keycloak,
//   getName,
// }: {
//   keycloak: any;
//   getName: any;
// } = storeToRefs(auths);
// const hasPermission = (authority: String) => {
//   if (keycloak.value.realmAccess.roles.includes(authority)) {
//     console.log("keycloak", true);
//     return true;
//   }
//   return false;
// };

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
  const content = [(columns.value || []).map((col) => wrapCsvValue(col.label))]
    .concat(
      props.rows.map((row) =>
        (columns.value || [])
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
onMounted(() => {
  columns.value = hasPermission([
    "GROUP_APOLLO_PROD_SUPPORT",
    "GROUP_APOLLO_OPERATIONS",
  ])
    ? store.$state.storeProviderCircuit
    : store.$state.storeProviderCircuitPSC!;
});
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
