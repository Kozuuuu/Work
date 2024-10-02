<template>
  <table-logs :rows="rows" :refresh="refresh"></table-logs>
</template>

<script setup lang="ts">
import { getElasticLogByStoreId } from "src/api/api";
const props = defineProps<{
  siteId: string;
}>();
import TableLogs from "src/components/tables/TableLogs.vue";
import { onMounted, ref } from "vue";
import { rowsLog } from "src/api/types";
import { useQuasar } from "quasar";
const $q = useQuasar();

const rows = ref<rowsLog[]>([]);

const refresh = async () => {
  $q.loading.show({
    message: `Gathering Activity Log for ${props.siteId}`,
  });
  try {
    rows.value = [];
    rows.value = await getElasticLogByStoreId(props.siteId);
    // console.log(rows.value);
  } catch {
  } finally {
    $q.loading.hide();
  }
};
onMounted(async () => {
  console.log("hello po");

  refresh();
});
</script>

<style lang="scss" scoped></style>
