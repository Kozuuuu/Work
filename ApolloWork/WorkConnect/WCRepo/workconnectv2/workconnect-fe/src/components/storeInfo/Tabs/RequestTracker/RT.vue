<template>
  <div>
    <q-table
      :columns="columns"
      :rows="rows"
      row_key="id"
      :loading="rows.length === 0"
      dense
    >
      <template #body-cell-id="props">
        <q-td :props="props" class="rt-table-column">
          {{ props.row.id }}<br />
          <a :href="props.row.link" target="_blank">{{ props.row.Subject }}</a>
          <br />
          {{ props.row.Creator }}
        </q-td>
      </template>

      <template #body-cell-Queue="props">
        <q-td :props="props" class="rt-table-column">
          {{ props.row.Queue }}<br />
          {{ props.row.Owner }}
        </q-td>
      </template>
      <template #body-cell-Created="props">
        <q-td :props="props" class="rt-table-column">
          {{ formatDate(props.row.Created) }}<br />
          {{ formatDate(props.row.LastUpdated) }}
        </q-td>
      </template>
      <template #body-cell-Status="props">
        <q-td :props="props" class="text-uppercase rt-table-column">
          {{ props.row.Status }}
        </q-td>
      </template>
    </q-table>
  </div>
</template>

<script setup lang="ts">
import { QTableProps } from "quasar";
import { formatDate } from "src/utils/helper";
import { ref, onMounted } from "vue";
import { getTickets } from "src/api/api";
import { useQuasar } from "quasar";
import { Iticket } from "src/api/types";
const $q = useQuasar();
const props = defineProps<{
  siteId: string;
}>();
const rows = ref<Iticket[]>([]);
const columns = [
  {
    label: "Subject/Requestor",
    align: "center",
    field: "id",
    name: "id",
    sortable: false,
  },
  {
    label: "Queue/Owner",
    align: "center",
    field: "Queue",
    name: "Queue",
    sortable: false,
  },
  {
    label: "Created/Last Updated",
    align: "center",
    field: "Created",
    name: "Created",
    sortable: false,
  },
  {
    label: "Status",
    align: "center",
    field: "Status",
    name: "Status",
    sortable: false,
  },
] as QTableProps["columns"];

const getTicketDetails = async () => {
  try {
    $q.loading.show();
    const tickets = await getTickets(props.siteId);
    tickets.sort(
      (a: Iticket, b: Iticket) =>
        new Date(b.LastUpdated).getTime() - new Date(a.LastUpdated).getTime()
    );
    rows.value = tickets;
  } catch (error) {
    $q.loading.hide();
  }
  $q.loading.hide();
};

onMounted(() => {
  getTicketDetails();
});
</script>

<style scoped>
.rt-table-column {
  max-width: 300px;
  white-space: pre-wrap;
}
</style>
