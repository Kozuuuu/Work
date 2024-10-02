<template>
  <q-page padding>
    <q-card flat>
      <q-separator />
      <q-select
        v-model="timeSelected"
        bordered
        :options="timeOptions"
        filled
        dense
        emit-value
        map-options
        style="width: 250px"
        class="q-ma-sm"
      />
      <div class="history-graph-cotainer">
        <iframe
          class="iframe-class"
          v-for="panelId in panelIds"
          :src="generateUrl(panelId)"
          frameborder="0"
        ></iframe>
      </div> </q-card
  ></q-page>
</template>

<script setup lang="ts">
import { ref } from "vue";
const panelIds = [2, 4, 6];
const timeSelected = ref("7d");
const timeOptions = [
  { label: "Last 7 days", value: "7d" },
  { label: "Last 15 days", value: "15d" },
  { label: "Last 30 days", value: "1M" },
  { label: "Last 3 months", value: "3M" },
  { label: "Last 6 months", value: "6M" },
  { label: "Last 9 months", value: "9M" },
  { label: "Last 1 years", value: "1y" },
  { label: "Last 2 years", value: "2y" },
];
const theme = ref("light");
const generateUrl = (panelId: number) => {
  return `http://grafana-sandbox.apolloglobal.net/d-solo/SoFpfh0Sz/zabbix-dashboard?orgId=1&from=now-${timeSelected.value}&to=now&panelId=${panelId}&theme=${theme.value}`;
};
</script>

<style scoped>
.history-graph-cotainer {
  max-width: 1800px;
  gap: 0.5em;
}

.history-graph-cotainer > iframe {
  width: 100%;
  min-width: 200px;
  /* max-width: 800px; */
  aspect-ratio: 16/7;
}

@media screen and (min-width: 850px) {
  .history-graph-cotainer {
    display: grid;
    grid-template-columns: 1fr 1fr;
  }
}
.iframe-class {
  border: 1px solid rgb(202, 202, 202, 0.8);
}
</style>
