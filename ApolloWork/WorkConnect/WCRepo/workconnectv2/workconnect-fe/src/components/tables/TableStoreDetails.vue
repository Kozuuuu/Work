<template>
  <q-table
    :columns="columns"
    :filter="filter"
    :rows="rows"
    :pagination="{
      rowsPerPage: -1,
      sortBy: 'zabbix_down_duration',
      descending: false,
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
      <!-- <q-tr :props="props" @click="handleClick(props.row.site_id)">
        <q-td v-for="column in columnsField" :key="column" :props="props">
          {{ props.row[column] }}
        </q-td>
      </q-tr> -->
      <q-tr :props="props" @click="handleClick(props.row.site_id)">
        <q-td key="site_id" :props="props">
          <span>
            {{ props.row.site_id }}
          </span>
          <!-- <div style="height: 10px; width: 10px; background-color: red"></div> -->
        </q-td>
        <q-td key="store_description" :props="props">
          {{ props.row.store_description }}
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
        <q-td key="zabbix_down_duration" :props="props" class="table-wrapper">
          <span>
            <img
              v-if="(calculateDownTime(props.row.zabbix_down_duration) as DownTimeResult).days !== undefined"
              :src="getDownTimeImage((calculateDownTime(props.row.zabbix_down_duration) as DownTimeResult).days)"
              alt="Status Image"
              class="status-image"
            />
            {{
              (
                calculateDownTime(
                  props.row.zabbix_down_duration
                ) as DownTimeResult
              ).days !== undefined
                ? (
                    calculateDownTime(
                      props.row.zabbix_down_duration
                    ) as DownTimeResult
                  ).timeString
                : "UP on Zabbix"
            }}
          </span>
        </q-td>
        <!-- <q-td key="zabbix_down_duration" :props="props">
          {{ calculateDownTime(props.row.zabbix_down_duration) }}
        </q-td> -->
        <q-td key="prometheus_down_duration" :props="props">
          {{ calculateDownTime(props.row.prometheus_down_duration) }}
        </q-td>
        <q-td key="primary_provider" :props="props">
          {{ props.row.primary_provider }}
        </q-td>
        <q-td key="last_change_primary" :props="props">
          {{ props.row.last_change_primary }}
        </q-td>
        <!-- <q-td key="primary_circuit_status" :props="props">
          {{ props.row.primary_circuit_status }}
        </q-td> -->

        <q-td key="backup_provider" :props="props">
          {{ props.row.backup_provider }}
        </q-td>
        <q-td key="last_change_backup" :props="props">
          {{ props.row.last_change_backup }}
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
        <q-td key="latitude" :props="props">
          {{ props.row.latitude }}
        </q-td>
        <q-td key="longitude" :props="props">
          {{ props.row.longitude }}
        </q-td>

        <!-- <q-td key="backup_circuit_status" :props="props">
          {{ props.row.backup_circuit_status }}
        </q-td> -->
      </q-tr>
    </template>
  </q-table>
  <!-- <q-btn label="Click me" color="primary" @click="inception = true" /> -->

  <q-dialog v-model="dashbordDetials">
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
import {
  uptimeToDuration7D,
  uptimeToDuration24H,
  calculateDownTime,
  DownTimeResult,
} from "src/utils/helper";
import { insertWorkconnectLog } from "src/api/api";

import Downtime_Yellow from "/img/Downtime-Yellow.png";
import Downtime_Orange from "/img/Downtime-Orange.png";
import One_Exclamation from "/img/One-Exclamation.png";
import Two_Exclamation from "/img/Two-Exclamation.png";

import { hasPermission } from "src/utils/helper";

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
  loopbackVal: "uptime" | "duration";
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
  // "loopback_0",
  // "loopback_1",
  // "loopback_2",
  // "loopback_0_24h",
  // "loopback_1_24h",
  // "loopback_2_24h",
  "zabbix_down_duration",
  //"prometheus_down_duration",
  "primary_provider",
  //"last_change_primary",
  // "primary_circuit_status",
  "backup_provider",
  //"last_change_backup",
  // "backup_circuit_status",
  "region",
  "province",
  "city",
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

// const getDownTimeColor = (days: number): string => {
//   if (days < 1) {
//     return "downtimecolor-yellow";
//   } else if (days < 3) {
//     return "downtimecolor-orange";
//   } else if (days < 5) {
//     return "downtime-red";
//   } else if (days > 7) {
//     return "downtimecolor-carmine";
//   }
//   // You can add more conditions if needed
//   return ""; // Default color or class if none of the conditions are met
// };

const getDownTimeImage = (days: number) => {
  if (days < 1) {
    return Downtime_Yellow;
  }
  if (days < 3) {
    return Downtime_Orange;
  }
  if (days < 7) {
    return One_Exclamation;
  }
  if (days >= 7) {
    return Two_Exclamation;
  } else return "";
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
.down_indicator {
  background-color: red;
}

/* .downtimecolor-yellow {
  border: 3px solid yellow;
}

.downtimecolor-orange {
  border: 3px solid orange;
}

.downtimecolor-red {
  border: 3px solid red;
}

.downtimecolor-carmine {
  border: 3px solid hsl(352 , 97% , 31%);
} */

.table-wrapper span {
  display: flex;
  justify-content: space-between;
  align-content: center;
}

.status-image {
  width: 20px;
  height: 20px;
}
</style>
