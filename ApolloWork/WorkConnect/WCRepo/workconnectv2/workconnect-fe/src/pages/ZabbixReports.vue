<template>
  <q-page padding>
    <q-input
      filled
      v-model="zabbixDateInput"
      dense
      readonly
      class="q-pb-lg"
      style="max-width: 300px"
      :rules="[(val) => (val && val.length > 0) || 'Please Select Time Period']"
    >
      <template v-slot:append>
        <q-icon name="event" class="cursor-pointer">
          <q-popup-proxy
            cover
            transition-show="scale"
            transition-hide="scale"
            ref="proxy"
          >
            <q-date v-model="zabbixDate" range @range-end="getAllCSVZabbix">
              <div class="row items-center justify-end">
                <!-- <q-btn label="Clear" color="primary" flat @click="clearDate" /> -->
                <!-- <q-btn
                  v-close-popup
                  label="Get Report"
                  color="primary"
                  flat
                  @click="getAllCSVZabbix"
                /> -->
              </div>
            </q-date>
          </q-popup-proxy>
        </q-icon>
      </template>
    </q-input>
    <table-zabbix :rows="rowZabbix" :close-btn="false"></table-zabbix>
  </q-page>
</template>

<script setup lang="ts">
import TableZabbix from "src/components/tables/TableZabbix.vue";
import { getZabbixCircuitReport } from "src/api/api";
import { useQuasar } from "quasar";
import { onMounted, ref, watch } from "vue";
import moment from "moment";

const proxy = ref({
  hide: () => {},
});
const $q = useQuasar();
const rowZabbix = ref<any[]>([]);
const zabbixDate = ref<{ from: string; to: string }>({
  from: "",
  to: "",
});
const zabbixDateInput = ref("");

const getAllCSVZabbix = async () => {
  const from = zabbixDate.value.from.split("/").join("-");
  const to = zabbixDate.value.to.split("/").join("-");
  zabbixDateInput.value = `${from} to ${to}`;
  proxy.value.hide();
  try {
    $q.loading.show({
      message: `Gathering Reports from ${zabbixDateInput.value} ...`,
    });
    rowZabbix.value = await getZabbixCircuitReport("", from, to);
  } catch (error) {
    $q.loading.hide();
    console.error("Fetch error:", error);
  } finally {
    zabbixDate.value.from = "";
    zabbixDate.value.to = "";

    $q.loading.hide();
  }
};
onMounted(() => {
  // getAllCSVZabbix();
});
watch(
  () => zabbixDate.value,
  (newVal, oldVal) => {
    zabbixDateInput.value = newVal.from + " to " + newVal.to;
  }
);
</script>

<style scoped></style>
