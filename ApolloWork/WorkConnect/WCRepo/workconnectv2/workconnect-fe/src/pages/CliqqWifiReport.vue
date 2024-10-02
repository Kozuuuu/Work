<template>
  <q-page padding>
    <q-table
      :columns="columns"
      :rows="cliqqDetails.cliqqRow"
      :pagination="{
        rowsPerPage: 15,
        sortBy: 'average_time_s',
        descending: true,
      }"
      :filter="filter"
      :dense="fullScreen"
      :separator="separator"
      :loading="loading"
      class="q-py-sm"
      no-data-label="Please Select Time Period"
    >
      <template v-slot:loading>
        <q-inner-loading
          showing
          color="primary"
          :label="`Gathering Cliqq wifi report ${dateRange.from} - ${dateRange.to}...`"
        />
      </template>
      <template #top-left>
        <div class="table-top-props">
          <div class="text-h6">
            {{ title }}
            <span class="text-subtitle2">{{
              cliqqDetails.dateRange.from + " to " + cliqqDetails.dateRange.to
            }}</span>
          </div>
        </div>
      </template>

      <template #top-right="props">
        <div class="table-top-props">
          <!-- <q-btn v-if="refresh" @click="refresh" icon="refresh" round flat /> -->
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
                  <q-date v-model="dateRange" range @range-end="refresh">
                    <!--  <div class="row items-center justify-end">
                       <q-btn @click="dateClear" label="Clear" /> 
                      <q-btn
                        v-close-popup
                        label="Get Report"
                        color="primary"
                        flat
                        @click="refresh"
                        :disable="dateRange.from == '' || dateRange.to == ''"
                      >
                        <q-tooltip
                          v-if="dateRange.from == '' || dateRange.to == ''"
                        >
                          Select Time Period First
                        </q-tooltip>
                      </q-btn> 
                    </div> -->
                  </q-date>
                </q-popup-proxy>
              </q-icon>
            </template>
          </q-input>
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
      </template>
      <template v-slot:body="props">
        <!-- <q-tr :props="props" @click="handleClick(props.row.site_id)">
        <q-td v-for="column in columnsField" :key="column" :props="props">
          {{ props.row[column] }}
        </q-td>
      </q-tr> -->
        <q-tr :props="props">
          <q-td key="site_id" :props="props">
            {{ props.row.site_id }}
          </q-td>
          <q-td key="average_time_s" :props="props">
            {{ secondsToMinutes(props.row.average_time_s) }}
          </q-td>
          <q-td key="session_count" :props="props">
            {{ props.row.session_count }}
          </q-td>
        </q-tr>
      </template>
    </q-table>
  </q-page>
</template>

<script setup lang="ts">
import { onMounted, ref } from "vue";
import { useQuasar, exportFile, QTableProps } from "quasar";
import { cliqq_wifi_report } from "src/api/api";
import { auth } from "src/stores/auth";
import { storeToRefs } from "pinia";
import { useSiteStore } from "src/stores/sites/stores";
import { secondsToMinutes } from "src/utils/helper";
const store = useSiteStore();
const { cliqqDetails } = storeToRefs(store);

const $q = useQuasar();
const fullScreen = ref(false);
const filter = ref("");
// const separator = (ref < "cell") | ("horizontal" > "horizontal");
const separator = ref<"cell" | "horizontal" | "vertical">("cell");
const mode = ref("");
const rows = ref([]);
const dateRange = ref({
  from: "",
  to: "",
});

const proxy = ref({ hide: () => {} });
const title = ref(`Cliqq Wifi Report`);
const loading = ref<boolean>(false);
const columns = [
  {
    name: "site_id",
    align: "left",
    label: "Site ID",
    field: (row) => row.site_id,
    format: (val) => `${val}`,
    sortable: true,
  },
  // {
  //   name: "total_time",
  //   align: "left",
  //   label: "Total Time In Minutes",
  //   field: (row) => row.total_time,
  //   sortable: true,
  // },
  {
    name: "average_time_s",
    align: "left",
    label: "Average Time In Minutes",
    // field: (row) => {
    //   let totalSeconds = row.average_time_s;
    //   let minutes = Math.floor(totalSeconds / 60);
    //   let seconds = totalSeconds % 60;

    //   return `${minutes}m ${Math.floor(seconds)}s`;
    // },
    field: (row) => row.average_time_s,

    sortable: true,
  },
  // {
  //   name: "number_of_users",
  //   align: "left",
  //   label: "Number of Users",
  //   field: (row) => row.number_of_users,
  //   sortable: true,
  // },
  {
    name: "session_count",
    align: "left",
    label: "Session Count",
    field: (row) => row.session_count,
    sortable: true,
  },
  // {
  //   name: "from",
  //   align: "left",
  //   label: "Start Date",
  //   field: (row) => row.from,
  //   sortable: true,
  // },
  // {
  //   name: "to",
  //   align: "left",
  //   label: "End Date",
  //   field: (row) => row.to,
  //   sortable: true,
  // }
] as QTableProps["columns"];
onMounted(async () => {
  // console.log(previousDate());
  // console.log(currentDate());
  // dateRange.value.from = previousDate();
  // dateRange.value.to = currentDate();
  // rows.value = await cliqq_wifi_report(
  //   dateRange.value.from,
  //   dateRange.value.to
  // );
});

const refresh = async () => {
  // rows.value = [];
  proxy.value.hide();
  const from = dateRange.value.from.split("/").join("-");
  const to = dateRange.value.to.split("/").join("-");
  loading.value = true;
  cliqqDetails.value.dateRange.from = from;
  cliqqDetails.value.dateRange.to = to;
  try {
    const cliqqResponse = await cliqq_wifi_report(from, to);
    cliqqDetails.value.cliqqRow = cliqqResponse;
    rows.value = cliqqResponse;
  } finally {
    loading.value = false;
    dateRange.value.from = "";
    dateRange.value.to = "";
  }
};
// const currentDate = () => {
//   const today = new Date();
//   return today.toISOString().split("T")[0]; // Format as YYYY-MM-DD
// };
// const previousDate = () => {
//   const previous = new Date();
//   previous.setDate(previous.getDate() - 1); // Subtract 1 day
//   return previous.toISOString().split("T")[0]; // Format as YYYY-MM-DD
// };
const storeKeyClock = auth();
const { keycloak, getName } = storeToRefs(storeKeyClock);
const hasPermission = (authority: any) => {
  // @ts-ignore
  if (keycloak.value.realmAccess.roles.includes(authority)) {
    console.log("keycloak", true);
    return true;
  }
  return false;
};

const exportTable = () => {
  // naive encoding to csv format
  // @ts-ignore
  const content = [columns.map((col) => wrapCsvValue(col.label))]
    .concat(
      rows.value.map((row) =>
        // @ts-ignore
        columns
          .map((col) =>
            wrapCsvValue(
              typeof col.field === "function"
                ? col.field(row)
                : row[col.field === void 0 ? col.name : col.field],
              col.format,
              row
            )
          )
          .join(",")
      )
    )
    .join("\r\n");
  const status = exportFile("Cliqq Wifi Report.csv", content, "text/csv");
  if (status !== true) {
    $q.notify({
      message: "Browser denied file download...",
      color: "negative",
      icon: "warning",
    });
  }
};
function wrapCsvValue(val: any, formatFn?: any, row?: any) {
  let formatted = formatFn !== void 0 ? formatFn(val, row) : val;

  formatted =
    formatted === void 0 || formatted === null ? "" : String(formatted);

  formatted = formatted.split('"').join('""');
  /**
   * Excel accepts \n and \r in strings, but some other CSV parsers do not
   * Uncomment the next two lines to escape new lines
   */
  // .split('\n').join('\\n')
  // .split('\r').join('\\r')

  return `"${formatted}"`;
}
</script>
<style scoped>
.table-top-props {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 0.5em;
  margin-right: 30px;
}
</style>
