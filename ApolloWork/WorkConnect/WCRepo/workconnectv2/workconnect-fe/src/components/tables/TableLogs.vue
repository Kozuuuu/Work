<template>
  <q-table
    :columns="columns"
    :rows="logsRows"
    dense
    :class="`q-py-sm my-sticky-virtscroll-table ${
      logsRows.length > 0 ? 'table-logs' : ''
    }`"
    row-key="user"
    :filter="filter"
    :loading="loading"
    virtual-scroll
    v-model:pagination="pagination"
    :rows-per-page-options="[0]"
    :visible-columns="visibleColumns"
    :no-data-label="tableLabel"
  >
    <template #top-left="props">
      <div class="top-props">
        <q-select
          v-if="logUsers && logsRows.length > 0"
          v-model="filter"
          filled
          dense
          label="Select User"
          :options="logUsers"
          clearable
          class="children-props"
        />
        <q-input
          v-if="logsRows.length > 0"
          v-model="filter"
          filled
          dense
          label="Search"
          :options="logUsers"
          clearable
          class="children-props"
        />

        <q-btn
          label="All Activity Logs"
          @click="getAll"
          outline
          class="children-props"
        ></q-btn>
        <q-input
          filled
          v-model="input"
          dense
          readonly
          label="Select Time Period"
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
                <q-date v-model="logDate" range @range-end="getLogs"> </q-date>
              </q-popup-proxy>
            </q-icon>
          </template>
        </q-input>

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
          class="children-props"
        />
      </div>
    </template>
    <template v-slot:body="props">
      <q-tr :props="props">
        <q-td key="user" :props="props">
          {{ props.row.user }}
        </q-td>
        <q-td key="clientIp" :props="props">
          {{ props.row.clientIp }}
        </q-td>
        <q-td key="action" :props="props">
          {{ props.row.action }}
        </q-td>
        <q-td key="service" :props="props">
          {{ props.row.service }}
        </q-td>
        <q-td key="payload" :props="props">
          {{ props.row.payload }}
        </q-td>
        <q-td key="timestamp" :props="props">
          {{
            moment
              .tz(props.row.timestampMilliSec, "Asia/Manila")
              .format("yyyy-MM-DD HH:mm")
          }}
        </q-td>
        <q-td key="roleGroup" :props="props" cursor-pointer>
          <!-- {{ props.row.roleGroup.join(", ") }} -->
          {{ truncateArray(props.row.roleGroup) }}
          <q-tooltip
            v-if="props.row.roleGroup.length > 3"
            max-width="400px"
            :offset="[10, -10]"
          >
            {{ props.row.roleGroup.join(",\n") }}
          </q-tooltip>
        </q-td>
        <q-td key="status" :props="props">
          {{ props.row.status }}
        </q-td>
        <q-td key="tenant" :props="props">
          {{ props.row.tenant }}
        </q-td>
      </q-tr>
    </template>
  </q-table>
</template>

<script setup lang="ts">
import { ref } from "vue";
import { Loading, QTableProps } from "quasar";

import moment from "moment-timezone";
import { rowsLog } from "src/api/types";
import { useSiteStore } from "src/stores/sites/stores";
import { storeToRefs } from "pinia";
const store = useSiteStore();
const { logDate, logsRows, logUsers } = storeToRefs(store);
const props = defineProps<{
  refresh?: () => void;
  getLogsPeriod?: () => void;
  getAll?: () => void;
}>();

const loading = ref(false);
const proxy = ref({ hide: () => {} });
const input = ref();

const filter = ref("");
const tableLabel = ref("Select Time Period");
const pagination = ref({
  rowsPerPage: logsRows.value.length,
  sortBy: "timestamp",
  descending: true,
});

const getLogs = () => {
  const from = logDate.value.from;
  const to = logDate.value.to;
  input.value = `${from} to ${to}`;
  try {
    tableLabel.value = "Gathering Data...";
    loading.value = true;
    props.getLogsPeriod?.();
    proxy.value.hide();
  } catch {
    tableLabel.value = "No Data Found";
  } finally {
    loading.value = false;
  }
};

const visibleColumns = ref([
  "user",
  "clientIp",
  "action",
  "service",
  "payload",
  "timestamp",
  "status",
]);

const columns = [
  {
    name: "user",
    align: "left",
    label: "User",
    field: "user",
    sortable: true,
  },
  {
    name: "clientIp",
    align: "left",
    label: "Client Ip",
    field: "clientIp",
    sortable: true,
  },
  {
    name: "action",
    align: "left",
    label: "Action",
    field: "action",
    sortable: true,
  },
  {
    name: "service",
    align: "left",
    label: "Service",
    field: "service",
    sortable: true,
  },
  {
    name: "payload",
    align: "left",
    label: "Payload",
    field: "payload",
    sortable: true,
  },
  {
    name: "timestamp",
    align: "left",
    label: "Timestamp",

    field: (row) => row.timestampMilliSec,

    sortable: true,
  },
  {
    name: "roleGroup",
    align: "left",
    label: "Role Group",
    field: "roleGroup",
    sortable: true,
    format: (val) => val.join(", "),
  },
  {
    name: "status",
    align: "left",
    label: "Status",
    field: "status",
    sortable: true,
  },
  {
    name: "tenant",
    align: "left",
    label: "Tenant",
    field: "tenant",
    sortable: true,
  },
] as QTableProps["columns"];

const truncateArray = (stringArray: string[]): string => {
  const maxItems = 3;
  if (stringArray.length <= 3) {
    return stringArray.join(", ");
  } else {
    const truncated = stringArray.slice(0, maxItems);
    return `${truncated.join(", ")}, + ${stringArray.length - maxItems} ...`;
  }
};
</script>

<style scoped>
td {
  max-width: 200px;
  white-space: pre-wrap;
}

.table-logs {
  max-width: 1920px;
  height: 600px;
  margin: 0 auto;
}
.top-props {
  width: 100%;
  display: flex;
  flex-direction: row;
  flex: 1;
  gap: 1em;
  flex-wrap: wrap;
  /* border: 1px solid black; */
}
.children-props {
  max-width: 250px;
  width: 100%;
}
</style>
