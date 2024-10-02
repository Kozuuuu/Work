<template>
  <q-page padding>
    <q-select
      v-model="timeSelected"
      bordered
      :options="timeOptions"
      filled
      dense
      emit-value
      map-options
      style="width: 250px"
      class="q-mb-sm"
    />
    <div class="history-graph-cotainer">
      <iframe
        v-for="panelId in panelIds"
        :src="generateUrl(panelId)"
        frameborder="0"
      ></iframe>
    </div>
  </q-page>
</template>

<script setup lang="ts">
import { ref, computed } from "vue";

const panelIds = [4, 6, 8, 10, 12, 14];
const timeSelected = ref("15d");
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
const generateUrl = (panelId: number) => {
  return `https://grafana.apolloglobal.net/d-solo/h2GD6-DIk/store-count-history?orgId=1&from=now-${timeSelected.value}&to=now&panelId=${panelId}&theme=${theme.value}`;
};
const theme = ref("dark");
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
</style>
