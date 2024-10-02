<template>
    <q-page padding>

          <table-provider-circuit-report :data="providerCircuitData"/>

    </q-page>
  </template>

  <script setup lang="ts">
  import { onMounted, ref } from "vue";
  import TableProviderCircuitReport from "src/components/tables/TableProviderCircuitReport.vue";
  // import TableProviderInventory from "src/components/tables/TableProviderInventory.vue";
  import { getCircuitReport } from "src/api/api";
  import { useQuasar } from "quasar";

  const providerCircuitData = ref([]);
  const $q = useQuasar();

  const theme = ref("light");

  async function getCircuitReportData(){
    try {
      providerCircuitData.value = await getCircuitReport();
      console.log(providerCircuitData);
    } catch (error){
      console.log("Error on Circuit Report Data:", error);
    }
  }

  onMounted(async () => {
    try {
      getCircuitReportData();
    } catch (error) {
      console.log(error);
      $q.loading.hide();
    }
    $q.loading.hide();
  });
  </script>

  <style lang="scss" scoped>
  </style>
