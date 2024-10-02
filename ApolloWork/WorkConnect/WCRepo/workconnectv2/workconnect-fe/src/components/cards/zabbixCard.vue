<template>
  <div>
    {{ circuitType }} IP: <span class="text-primary text-bold">{{ ip }}</span>
    <br />
    <div v-if="status !== undefined && status !== null">
      <span
        :class="status === 0 ? 'text-positive text-bold' : 'text-negative'"
        >{{
          status === 0
            ? lastChanged
              ? `UP Since: ${timeDifference(lastChanged, new Date())}`
              : "UP"
            : lastChanged
            ? `Down Since: ${timeDifference(lastChanged, new Date())}`
            : "DOWN"
        }}</span
      >
    </div>
    <q-card v-if="events && events.length > 0" class="q-pa-sm">
      <div v-for="(event, index) in events" :key="index" class="">
        <div class="q-ma-sm" style="display: flex; flex-direction: column">
          <span>
            {{ formatDate(event.start) }} Duration:
            {{ timeDifference(event.start, event.end) }}
          </span>
          <!-- <span> End: {{ formatDate(event.end) }}</span>
          <span> Duration: {{ timeDifference(event.start, event.end) }}</span> -->
        </div>
        <q-separator />
      </div>
    </q-card>
    <div v-else class="q-py-md">No Down Events Found</div>
  </div>
</template>

<script setup lang="ts">
import { time } from "echarts";
import { zabbixEvents } from "src/api/types";
import { ref } from "vue";
import { formatDate } from "src/utils/helper";
const props = defineProps<{
  circuitType: string;
  ip?: string;
  status?: number;
  events?: zabbixEvents[];
  lastChanged?: string;
}>();

const timeDifference = (start: string, end: string | Date) => {
  const diffInMilliseconds = Math.abs(
    new Date(end).getTime() - new Date(start).getTime()
  );
  const seconds: number = Math.floor(diffInMilliseconds / 1000);
  const minutes: number = Math.floor(seconds / 60);
  const hours: number = Math.floor(minutes / 60);
  const days: number = Math.floor(hours / 24);
  const months: number = Math.floor(days / 30);

  const formatTime = (time: number, unit: string) =>
    time > 0 ? `${time}${unit}` : "";

  const formattedDuration = [
    formatTime(months, "mo"),
    formatTime(days % 30, "d"),
    formatTime(hours % 24, "h"),
    formatTime(minutes % 60, "m"),
  ]
    .filter(Boolean)
    .join(" ");

  return formattedDuration || "0 seconds";
};
</script>

<style scoped></style>
