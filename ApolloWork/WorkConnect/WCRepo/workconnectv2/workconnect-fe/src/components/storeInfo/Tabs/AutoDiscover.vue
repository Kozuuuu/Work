<template>
  <div>
    <!-- <div class="text-uppercase text-bold">store id: {{ storeId }}</div> -->

    <q-table
      :columns="macAndGatewayColumn"
      :rows="macAndGatewayRow"
      separator="cell"
      class="border-box q-mt-md"
      :pagination="{
        rowsPerPage: 10,
      }"
      hide-bottom
    >
      <template #top-left="props">
        <div class="text-uppercase text-bold">Mac and Gateway Ip</div>
      </template>
      <template #top-right="props">
        <q-btn
          @click="parseMacAndGateway"
          label="Real-time Auto-Discover"
          no-caps
        >
        </q-btn>
        <!-- <q-btn @click="pingStore(storeId)">ping</q-btn> -->
      </template>
    </q-table>

    <q-table
      :columns="publcIpAndProviderColumn"
      :rows="publcIpAndProviderRow"
      separator="cell"
      class="border-box q-mt-md"
      :pagination="{
        rowsPerPage: 10,
      }"
      hide-bottom
    >
      <template #top-left="props">
        <div class="text-uppercase text-bold">Public Ip and Provider</div>
      </template>
      <template #top-right="props">
        <q-btn
          @click="parsePublicIpAndProvider"
          label="Real-time Auto-Discover"
          no-caps
        >
        </q-btn>
      </template>
    </q-table>
    <!-- <q-card class="q-mt-md">
      <div class="q-pa-sm">
        <div
          class="q-pb-sm"
          style="display: flex; align-items: center; justify-content: center"
        >
          <span class="text-bold">PING:</span>
          <q-space />
          <q-btn icon="network_ping" rounded @click="ping">Trace Route</q-btn>
        </div>
        <q-separator />
        <pre>{{ pingReponse }}</pre>
      </div></q-card
    > -->

    <q-table
      :columns="pingColumn"
      :rows="pingStoreRow"
      separator="cell"
      class="border-box q-mt-md"
      :pagination="{
        rowsPerPage: 10,
      }"
      hide-bottom
      dense
    >
      <template #top-left="props">
        <div class="text-uppercase text-bold">Ping Store</div>
      </template>
      <template #top-right="props">
        <q-btn @click="pingLoopbacks" label="Ping loopback 0,1 & 2" no-caps>
        </q-btn>
      </template>

      <template #body="props">
        <q-tr :props="props">
          <q-td
            key="lo0"
            :props="props"
            :class="
              checkPacketLoss(props.row.lo0) ? 'text-negative' : 'text-accent'
            "
          >
            <pre>{{ props.row.lo0 }}</pre>
          </q-td>
          <q-td
            key="lo1"
            :props="props"
            :class="
              checkPacketLoss(props.row.lo1) ? 'text-negative' : 'text-accent'
            "
          >
            <pre>{{ props.row.lo1 }}</pre>
          </q-td>
          <q-td
            key="lo2"
            :props="props"
            :class="
              checkPacketLoss(props.row.lo2) ? 'text-negative' : 'text-accent'
            "
          >
            <pre>{{ props.row.lo2 }}</pre>
          </q-td>
        </q-tr>
      </template>
    </q-table>
    <q-table
      :rows="traceRouteRow"
      separator="cell"
      class="border-box q-mt-md"
      :pagination="{
        rowsPerPage: 10,
      }"
      row-key="Circuit"
      hide-bottom
      dense
    >
      <template #top-left="props">
        <div class="text-uppercase text-bold">Trace Route</div>
      </template>
      <template #top-right="props">
        <div style="display: flex; gap: 0.5em">
          <q-btn @click="traceRoute('store')" label="Store" no-caps />
          <q-btn @click="traceRoute('primary')" label="Primary" no-caps />
          <q-btn @click="traceRoute('backup')" label="Backup" no-caps />
        </div>
      </template>
      <template #body="props">
        <q-tr :props="props">
          <q-td key="Circuit" :props="props">
            {{ props.row.Circuit }}
          </q-td>
          <q-td key="traceroute" :props="props">
            <pre>{{ props.row.traceroute }}</pre>
          </q-td>
        </q-tr>
      </template>
    </q-table>
    <q-card class="q-mt-md q-pa-sm row gap-1 items-center fit-content">
      <q-btn @click="serial" label="Auto-Discover Serial Number" no-caps />
      <span> {{ serialNumber }}</span>
    </q-card>
  </div>
</template>

<script setup lang="ts">
import {
  macAndGateway,
  publicIpAndProvider,
  IcircuitInfo,
} from "src/api/types";
import { ref, onMounted } from "vue";
import { QTableProps, useQuasar } from "quasar";
import {
  getMacAndGateway,
  getPingStore,
  getPublicIp,
  getMacAndPublicIp,
  insertWorkconnectLog,
  getLoopbackPing,
  getTraceRoute,
  getSNMPSerial,
} from "src/api/api";

import axios from "axios";

const props = defineProps<{
  storeId: string;
  circuitInfo?: IcircuitInfo;
}>();
const $q = useQuasar();
const serialNumber = ref("");
const pingReponse = ref("");
const lo0Provider = ref("");
const macAndGatewayVal = ref<macAndGateway>();
const publcIpAndProviderVal = ref<publicIpAndProvider>();
const traceRouteRow = ref<{ Circuit: string; traceroute: string }[]>([]);
const pingStoreRow = ref<{ lo0: string; lo1: string; lo2: string }[]>([
  {
    lo0: "",
    lo1: "",
    lo2: "",
  },
]);
const macAndGatewayRow = ref<macAndGateway[]>([
  {
    gtw_primary: props.circuitInfo?.gtw_primary || "",
    mac_backup: props.circuitInfo?.mac_backup || "",
    gtw_backup: props.circuitInfo?.gtw_backup || "",
    mac_primary: props.circuitInfo?.mac_primary || "",
  },
]);
const publcIpAndProviderRow = ref<publicIpAndProvider[]>([
  {
    // store_provider: lo0Provider.value,
    public_ip_primary: props.circuitInfo?.public_ip_primary || "",
    provider_primary: props.circuitInfo?.provider_primary || "",
    public_ip_backup: props.circuitInfo?.public_ip_backup || "",
    provider_backup: props.circuitInfo?.provider_backup || "",
  },
]);
const pingColumn = [
  {
    name: "lo0",
    align: "left",
    label: "Store ping",
    field: (row) => row.lo1,
  },
  {
    name: "lo1",
    align: "left",
    label: "Primary ping",
    field: (row) => row.lo1,
  },
  {
    name: "lo2",
    align: "left",
    label: "Backup ping",
    field: (row) => row.lo2,
  },
] as QTableProps["columns"];

// const traceRouteCol = [
//   {
//     name: "store",
//     align: "left",
//     label: "Store",
//     field: "store",
//   },
//   {
//     name: "primary",
//     align: "left",
//     label: "Primary",
//     field: "primary",
//   },
//   {
//     name: "backup",
//     align: "left",
//     label: "Backup",
//     field: "backup",
//   },
// ] as QTableProps["columns"];
const publcIpAndProviderColumn = [
  // {
  //   name: "store_provider",
  //   align: "left",
  //   label: "Store Provider",
  //   field: "store_provider",
  //   sortable: false,
  // },
  {
    name: "public_ip_primary",
    align: "left",
    label: "Public Ip Primary",
    field: "public_ip_primary",
    sortable: false,
  },
  {
    name: "provider_primary",
    align: "left",
    label: "Provider Primary",
    field: "provider_primary",
    sortable: false,
  },
  {
    name: "public_ip_backup",
    align: "left",
    label: "Public Ip Backup",
    field: "public_ip_backup",
    sortable: false,
  },
  {
    name: "provider_backup",
    align: "left",
    label: "Provider backup",
    field: "provider_backup",
    sortable: false,
  },
] as QTableProps["columns"];

const macAndGatewayColumn = [
  {
    name: "mac_primary",
    align: "left",
    label: "Mac Primary",
    field: "mac_primary",
    sortable: false,
  },
  {
    name: "gtw_primary",
    align: "left",
    label: "Gateway Primary",
    field: "gtw_primary",
    sortable: false,
  },
  {
    name: "mac_backup",
    align: "left",
    label: "Mac Backup",
    field: "mac_backup",
    sortable: false,
  },
  {
    name: "gtw_backup",
    align: "left",
    label: "Gateway Backup",
    field: "gtw_backup",
    sortable: false,
  },
] as QTableProps["columns"];

const checkPacketLoss = (output: string): boolean => {
  const lines = output.split("\n");

  for (const line of lines) {
    if (line.includes("100% packet loss")) {
      return true;
    }
  }
  return false;
};
const serial = async () => {
  try {
    $q.loading.show({
      message: "Auto-discovering serial number " + props.storeId,
    });

    serialNumber.value = await getSNMPSerial(props.storeId);
  } finally {
    $q.loading.hide();
  }
};
// const ping = async () => {
//   $q.loading.show({ message: `Pinging Store ${props.storeId} ...` });
//   try {
//     const { pingMsg, provider } = await getPingStore(props.storeId);
//     lo0Provider.value = provider;
//     pingReponse.value = pingMsg;

//     publcIpAndProviderRow.value[0].store_provider = provider;
//   } catch (error) {
//     $q.loading.hide();
//     if (axios.isAxiosError(error)) {
//       if (error.response?.status === 401) {
//         $q.notify({
//           message: "Unauthorized Access Request failed with Status Code 401",
//           color: "negative",
//         });
//       } else {
//         throw error;
//       }
//     }
//   } finally {
//     $q.loading.hide();
//   }
// };
const pingLoopbacks = async () => {
  $q.loading.show({ message: `Pinging Store ${props.storeId} ...` });
  try {
    const loopback = await getLoopbackPing(props.storeId);
    pingStoreRow.value[0].lo0 = loopback[0];
    pingStoreRow.value[0].lo1 = loopback[1];
    pingStoreRow.value[0].lo2 = loopback[2];
    // console.log(loopback);
  } catch (error) {
    $q.loading.hide();
    if (axios.isAxiosError(error)) {
      if (error.response?.status === 401) {
        $q.notify({
          message: "Unauthorized Access Request failed with Status Code 401",
          color: "negative",
        });
      } else {
        throw error;
      }
    }
  } finally {
    $q.loading.hide();
  }
};
const parseMacAndGateway = async () => {
  $q.loading.show({
    message: "Gathering latest Mac and Gateway Ip data...",
  });
  try {
    insertWorkconnectLog(
      `auto discover mac and gateway ip for : ${props.storeId}`
    );

    const response = await getMacAndGateway(props.storeId);
    macAndGatewayVal.value = response;
    if (macAndGatewayRow.value.length <= 1) {
      macAndGatewayRow.value.splice(1, 0, macAndGatewayVal.value);
    } else {
      macAndGatewayRow.value.splice(1, 1, macAndGatewayVal.value);
    }
  } catch (error) {
    $q.loading.hide();
    if (axios.isAxiosError(error)) {
      if (error.response?.status === 401) {
        $q.notify({
          message: "Unauthorized Access Request failed with Status Code 401",
          color: "negative",
        });
      } else {
        throw error;
      }
    }
  } finally {
    $q.loading.hide();
  }
};

const parsePublicIpAndProvider = async () => {
  $q.loading.show({
    message: "Gathering latest Public Ip and Provider data...",
  });
  try {
    const response = await getPublicIp(props.storeId);
    publcIpAndProviderVal.value = {
      ...response,
      store_provider: lo0Provider.value,
    };
    if (publcIpAndProviderRow.value.length <= 1) {
      publcIpAndProviderRow.value.splice(1, 0, publcIpAndProviderVal.value);
    } else {
      publcIpAndProviderRow.value.splice(1, 1, publcIpAndProviderVal.value);
    }
    insertWorkconnectLog(
      `auto discover public ip and provider for : ${props.storeId}`
    );
  } catch (error) {
    if (axios.isAxiosError(error)) {
      if (error.response?.status === 401) {
        $q.notify({
          message: "Unauthorized Access Request failed with Status Code 401",
          color: "negative",
        });
      }
    }
  } finally {
    $q.loading.hide();
  }
};
const traceRoute = async (type: "store" | "primary" | "backup") => {
  $q.loading.show({ message: `Tracing Route for ${props.storeId} ${type}...` });
  try {
    const tracerouteResponse = await getTraceRoute(props.storeId, type);
    console.log(tracerouteResponse);

    if (type === "store") {
      traceRouteRow.value[0].traceroute = tracerouteResponse;
    }
    if (type === "primary") {
      traceRouteRow.value[1].traceroute = tracerouteResponse;
    }
    if (type === "backup") {
      traceRouteRow.value[2].traceroute = tracerouteResponse;
    }

    // console.log(loopback);
  } catch (error) {
    $q.loading.hide();
    if (axios.isAxiosError(error)) {
      if (error.response?.status === 401) {
        $q.notify({
          message: "Unauthorized Access Request failed with Status Code 401",
          color: "negative",
        });
      } else {
        throw error;
      }
    }
  } finally {
    $q.loading.hide();
  }
};
// const macAndPublicIp = async () => {
//   insertWorkconnectLog(
//     `Current value from db mac & public ip for : ${props.storeId}`
//   );
//   const {
//     mac_backup,
//     mac_primary,
//     gtw_backup,
//     gtw_primary,
//     public_ip_backup,
//     public_ip_primary,
//     provider_backup,
//     provider_primary,
//   } = await getMacAndPublicIp(props.storeId);

//   macAndGatewayRow.value = [];
//   publcIpAndProviderRow.value = [];

//   macAndGatewayRow.value.unshift({
//     mac_backup,
//     mac_primary,
//     gtw_backup,
//     gtw_primary,
//   });
//   publcIpAndProviderRow.value.unshift({
//     public_ip_backup,
//     public_ip_primary,
//     provider_backup,
//     provider_primary,
//   });
// };

onMounted(async () => {
  // try {
  //   $q.loading.show();
  //   await macAndPublicIp();
  // } catch (error) {
  //   $q.loading.hide();
  // } finally {
  //   $q.loading.hide();
  // }
  traceRouteRow.value = [
    {
      Circuit: "STORE",
      traceroute: "",
    },
    {
      Circuit: "PRIMARY",
      traceroute: "",
    },
    {
      Circuit: "BACKUP",
      traceroute: "",
    },
  ];
});
</script>

<style scoped>
.td_limit {
  /* max-width: 50ch;
  white-space: pre-wrap; */
}
</style>
