<template>
  <div>
    <q-table
      :title="'Zabbix Report'"
      :filter="filter"
      :columns="columns"
      :rows="props.rows"
      :pagination="{
        rowsPerPage: 15,
        sortBy: 'duration_in_min',
        descending: true,
      }"
      :dense="fullScreen"
      :separator="separator"
      class="q-py-sm"
      no-data-label="Select Time period"
    >
      <template #top-right="props">
        <div class="table-top-props">
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
        <q-tr :props="props">
          <q-td key="name" :props="props">
            {{ props.row.name }}
          </q-td>
          <q-td key="store_and_circuit_label" :props="props">
            {{ props.row.store_and_circuit_label }}
          </q-td>
          <q-td key="start" :props="props">
            {{ formatDate(props.row.start) }}
          </q-td>
          <q-td key="end" :props="props">
            {{ formatDate(props.row.end) }}
          </q-td>
          <q-td key="duration_in_min" :props="props">
            {{ convertMinutesToDHM(props.row.duration_in_min) }}
          </q-td>
        </q-tr>
      </template>
    </q-table>
  </div>
</template>

<script setup lang="ts">
import { QTableProps } from "quasar";
import { ref } from "vue";
import { useQuasar, exportFile } from "quasar";
import { formatDate } from "src/utils/helper";
const $q = useQuasar();
const fullScreen = ref(false);
const filter = ref("");
const props = defineProps<{ rows: any[]; closeBtn: boolean }>();
const mode = ref("");
const separator = ref<"cell" | "horizontal">("horizontal");
const columns = [
  {
    name: "name",
    align: "left",
    label: "Name",
    field: "name",
    sortable: true,
  },
  {
    name: "store_and_circuit_label",
    align: "left",
    label: "Store and Circuit Label",
    field: "store_and_circuit_label",
    sortable: true,
  },
  {
    name: "start",
    align: "left",
    label: "Start",
    field: "start",
    sortable: true,
  },
  {
    name: "end",
    align: "left",
    label: "End",
    field: "end",
    sortable: true,
  },
  {
    name: "duration_in_min",
    align: "left",
    label: "Duration Down",
    field: (row) => row.duration_in_min,
    sortable: true,
  },
] as QTableProps["columns"];

// {
//         "name": "ST-2627",
//         "duration_in_min": 49.0000,
//         "store_and_circuit_label": "Store",
//         "start": "2024-01-20T10:34:44.000+00:00",
//         "end": "2024-01-20T11:23:44.000+00:00"
//     },

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
const convertMinutesToDHM = (minutes: number) => {
  if (typeof minutes !== "number" || minutes < 0) return "Invalid input";

  const totalHours = Math.floor(minutes / 60);
  const d = Math.floor(totalHours / 24);
  const h = totalHours % 24;
  const m = Math.round(minutes % 60);

  let result = "";
  if (d > 0) {
    result += `${d} day${d > 1 ? "s" : ""}, `;
  }
  if (h > 0 || d === 0) {
    result += `${h} hour${h > 1 ? "s" : ""}, `;
  }
  if (m > 0 || (d === 0 && h === 0)) {
    result += `${m} min`;
  }

  return result;
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
  const fileName = `zabbix-report.csv`;

  const status = exportFile(fileName, content, "text/csv");

  if (status !== true) {
    $q.notify({
      message: "Browser denied file download...",
      color: "negative",
      icon: "warning",
    });
  }
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
</script>

<style scoped>
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
