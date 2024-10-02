<template>
  <q-page class="q-pa-sm container-width">
    <dashboard-card-social
      title="Stores"
      :prop_items="allStores"
      :table-layout="'storeDetails'"
    />
    <dashboard-card-social
      v-if="
        hasPermission(['GROUP_APOLLO_PROD_SUPPORT', 'GROUP_APOLLO_OPERATIONS'])
      "
      title="Down Stores"
      :prop_items="totalDownStores"
      :table-layout="'storeDetails'"
    />
    <q-card>
      <table-store-details
        :rows="rows"
        :title="`Down Stores List`"
        :closeBtn="false"
        :loopback-val="'duration'"
      ></table-store-details>
    </q-card>
    <div>
      <span
        v-if="
          hasPermission([
            'GROUP_APOLLO_PROD_SUPPORT',
            'GROUP_APOLLO_OPERATIONS',
          ])
        "
        :class="!showMap ? 'text-subtitle2' : ''"
        >Show Down History</span
      >
      <q-toggle v-model="showMap" /><span
        :class="showMap ? 'text-subtitle2' : ''"
        >Show Map</span
      >
    </div>

    <!-- <q-toggle v-model="showHistory"> Show Down Stores History</q-toggle> -->
    <q-card v-show="showMap" style="max-width: 1920px; margin: 0 auto">
      <div id="map-down" style="height: 600px"></div>
    </q-card>
    <q-card
      v-if="
        hasPermission(['GROUP_APOLLO_PROD_SUPPORT', 'GROUP_APOLLO_OPERATIONS'])
      "
      v-show="!showMap"
      class="iframe-card"
    >
      <div class="history-graph-container">
        <q-select
          :options="timeOptions"
          v-model="timeSelected"
          map-options
          emit-value
          dense
          style="max-width: 300px"
          class="q-pa-sm"
          outlined
        ></q-select>
        <iframe :src="generateUrl()" frameborder="200"></iframe>
      </div>
    </q-card>
    <!-- <card-social
      title="Problematic Stores"
      :prop_items="problematicStores"
      :table-layout="'storeDetails'"
    /> -->

    <!-- <card-social
      title="Problematic Primary Circuits"
      :prop_items="primaryCircuit"
      :table-layout="'storeDetails'"
    />

    <card-social
      title="Problematic Backup Circuits"
      :prop_items="backupCircuit"
      :table-layout="'storeDetails'"
    />
    <card-social
      title="Store Connectivity"
      :prop_items="storeConnectivity"
      :table-layout="'storeDetails'"
    />
    <card-social
      title="Store Health Status"
      :prop_items="storeStatus"
      :table-layout="'storeDetails'"
    /> -->
    <!-- <div class="csv-buttons">
      <q-btn
        @click="extractDataCSV"
        color="primary"
        icon-right="archive"
        label="Export Inventory csv"
        no-caps
      />
      <q-btn
        @click="extractStoreCSV"
        color="primary"
        icon-right="archive"
        label="Export Store Data csv"
        no-caps
      />
    </div> -->
    <q-btn icon="refresh" flat rounded class="refresh-btn" @click="refresh"
      >Refresh</q-btn
    >
  </q-page>
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from "vue";
import L from "leaflet";
import { storeToRefs } from "pinia";
import TableDownCircuits from "src/components/tables/TableDownCircuits.vue";
import TableStoreDetails from "src/components/tables/TableStoreDetails.vue";
import {
  prometheusData,
  nmsData,
  extractCSV,
  extractStoreDataCSV,
  getAllStoreCounts,
  getDetailsList,
} from "src/api/api";
import CardSocial from "src/components/cards/CardSocial.vue";
import DashboardCardSocial from "src/components/cards/DashboardCardSocial.vue";
import { useSiteStore } from "src/stores/sites/stores";
import { useQuasar } from "quasar";
import { IcountAllStore, countTypes, IdetailsListData } from "src/api/types.js";

import redPin from "/red-pin2.png";
import softYellowPin from "/softestyellow-pin.png";
import yellowPin from "/oneday-yellow-pin.png";
import darkRedPin from "/carmine-pin.png";
import orangePin from "/darkOrange-pin.png";
import { hasPermission } from "src/utils/helper";
const $q = useQuasar();

$q.loadingBar.setDefaults({
  color: "positive",
  size: "5px",
  position: "bottom",
});

const store = useSiteStore();
const showMap = ref(true);
const showHistory = ref(false);
const allStores = ref<countTypes[]>([]);
const totalDownStores = ref<countTypes[]>([]);
const totalZabbixDownStores = ref();
const problematicStores = ref<countTypes[]>([]);
const primaryCircuit = ref<countTypes[]>([]);
const backupCircuit = ref<countTypes[]>([]);
const circuit24hrs = ref<countTypes[]>([]);
const storeConnectivity = ref<countTypes[]>([]);
const storeStatus = ref<countTypes[]>([]);
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
// const downStoresPerProviders = ref<countTypes[]>([]);

const rows = ref<IdetailsListData[]>([]);

const getDownStores = async () => {
  rows.value = await getDetailsList("down_store");
  initializeMap();
  // showMap.value = false;
};

const setProblematicCircuits = async () => {
  if (Object.keys(store.$state.storeCounts).length === 0) {
    const count = await getAllStoreCounts();
    store.$state.storeCounts = count;
  }

  // totalZabbixDownStores.value = await getZabbixDownStores();
  // store.$state.storeCounts.totalZabbixDownStores = totalZabbixDownStores.value;

  if (hasPermission(["GROUP_APOLLO_PROD_SUPPORT", "GROUP_APOLLO_OPERATIONS"])) {
    allStores.value.push({
      title: "Total Stores",
      value: store.$state.storeCounts.totalStores,
      bgColor: "bg-info",

      bigSize: true,
    });

    allStores.value.push({
      title: "Temporarily Closed",
      value: store.$state.storeCounts.temporarilyClosed,
      bgColor: "bg-info",

      bigSize: true,
    });

    allStores.value.push({
      title: "Mikrotik Stores",
      value: store.$state.storeCounts.totalMikrotikStores,
      bgColor: "bg-info",

      bigSize: true,
    });

    allStores.value.push({
      title: "Ruijie Stores",
      value: store.$state.storeCounts.totalRuijiStores,
      bgColor: "bg-info",

      bigSize: true,
    });
    totalDownStores.value.push({
      title: "Prometheus Down Stores",
      value: store.$state.storeCounts.totalDownStores,
      bgColor: "bg-negative",
    });
    totalDownStores.value.push({
      title: "Zabbix Down Stores",
      value: store.$state.storeCounts.zabbixDownStores,
      bgColor: "bg-negative",
    });
  }
  if (hasPermission(["GROUP_PSC_USERS"])) {
    allStores.value.push({
      title: "Total Stores",
      value: store.$state.storeCounts.totalStores,
      bgColor: "bg-info",

      bigSize: true,
    });

    allStores.value.push({
      title: "Temporarily Closed",
      value: store.$state.storeCounts.temporarilyClosed,
      bgColor: "bg-info",
      bigSize: true,
    });
    allStores.value.push({
      title: "Down Stores",
      value: store.$state.storeCounts.totalDownStores,
      bgColor: "bg-negative",
      bigSize: true,
    });
  }

  // totalDownStores.value.push({
  //   title: "Mikrotik Down Stores",
  //   value: store.$state.storeCounts.totalDownMikrotik,
  //   bgColor: "#ab2e3c",
  //   routeValue: "",
  //   tableType: "down_mikrotik",
  // });
  // totalDownStores.value.push({
  //   title: "Ruijie Down Stores",
  //   value: store.$state.storeCounts.totalDownRuiji,
  //   bgColor: "#ab2e3c",
  //   routeValue: "",
  //   tableType: "down_ruijie",
  // });
  // problematicStores.value.push({
  //   title: "0% uptime availability (7days)",
  //   value: store.$state.storeCounts.problematicStores0_7d,
  //   bgColor: "bg-info",
  //   routeValue: "",
  //   tableType: "problematic0_7d",
  // });
  // problematicStores.value.push({
  //   title: "< 95% uptime availability (7days)",
  //   value: store.$state.storeCounts.problematicStoresLess95_7d,
  //   bgColor: "bg-info",
  //   routeValue: "",
  //   tableType: "problematic95_7d",
  // });
  // problematicStores.value.push({
  //   title: "< 95% uptime availability (24hrs)",
  //   value: store.$state.storeCounts.problematicStoresLess95_24hrs,
  //   bgColor: "bg-info",
  //   routeValue: "",
  //   tableType: "problematic95_24h",
  // });
  // problematicStores.value.push({
  //   title: "Wireless Only",
  //   value: store.$state.storeCounts.problematicWirelessOnly,
  //   bgColor: "bg-info",
  //   routeValue: "",
  //   tableType: "wireless_only",
  // });
  // problematicStores.value.push({
  //   title: "Single circuit",
  //   value: store.$state.storeCounts.problematicSingleCircuit,
  //   bgColor: "bg-info",
  //   routeValue: "",
  //   tableType: "single_circuit",
  // });

  // primaryCircuit.value.push({
  //   title: "0% uptime availability (7days)",
  //   value: store.$state.storeCounts.problematicPrimary0_7d,
  //   bgColor: "bg-info",
  //   routeValue: "",
  //   tableType: "primary0_7d",
  // });

  // primaryCircuit.value.push({
  //   title: "No Internet",
  //   value: store.$state.storeCounts.primaryCircuitNoInternet,
  //   bgColor: "bg-info",
  //   routeValue: "",
  //   tableType: "primary_no_internet",
  // });
  // primaryCircuit.value.push({
  //   title: "No Provider",
  //   value: store.$state.storeCounts.problematicPrimaryNoProvider,
  //   bgColor: "bg-info",
  //   routeValue: "",
  //   tableType: "primary_no_provider",
  // });
  // primaryCircuit.value.push({
  //   title: "Wireless",
  //   value: store.$state.storeCounts.primaryWireless,
  //   bgColor: "bg-info",
  //   routeValue: "",
  //   tableType: "primary_wireless",
  // });

  // backupCircuit.value.push({
  //   title: "0% uptime availability (7days)",
  //   value: store.$state.storeCounts.problematicBackup0_7d,
  //   bgColor: "bg-info",
  //   routeValue: "",
  //   tableType: "backup0_7d",
  // });
  // backupCircuit.value.push({
  //   title: "< 95% uptime availability (7days)",
  //   value: store.$state.storeCounts.problematicBackupLess95_7d,
  //   bgColor: "bg-info",
  //   routeValue: "",
  //   tableType: "backup95_7d",
  // });
  // backupCircuit.value.push({
  //   title: "100% uptime availability (7days)",
  //   value: store.$state.storeCounts.backup100_7d,
  //   bgColor: "bg-info",
  //   routeValue: "",
  //   tableType: "backup100_7d",
  // });
  // backupCircuit.value.push({
  //   title: "< 95% uptime availability (24hrs)",
  //   value: store.$state.storeCounts.problematicBackupLess95_24hrs,
  //   bgColor: "bg-info",
  //   routeValue: "",
  //   tableType: "backup95_24h",
  // });
  // backupCircuit.value.push({
  //   title: "No Internet",
  //   value: store.$state.storeCounts.backupCircuitNoInternet,
  //   bgColor: "bg-info",
  //   routeValue: "",
  //   tableType: "backup_no_internet",
  // });
  // backupCircuit.value.push({
  //   title: "No Provider",
  //   value: store.$state.storeCounts.problematicBackupNoProvider,
  //   bgColor: "bg-info",
  //   routeValue: "",
  //   tableType: "backup_no_provider",
  // });
  // backupCircuit.value.push({
  //   title: "Wired",
  //   value: store.$state.storeCounts.backupWired,
  //   bgColor: "bg-info",
  //   routeValue: "",
  //   tableType: "backup_wired",
  // });
  // storeConnectivity.value.push({
  //   title: "Dual Circuit",
  //   value: store.$state.storeCounts.dual_circuit_7d,
  //   bgColor: "bg-info",
  //   routeValue: "",
  //   tableType: "dual_circuit_7d",
  // });
  // storeConnectivity.value.push({
  //   title: "Primary Only Up",
  //   value: store.$state.storeCounts.primary_only_7d,
  //   bgColor: "bg-info",
  //   routeValue: "",
  //   tableType: "primary_only_7d",
  // });
  // storeConnectivity.value.push({
  //   title: "Backup Only Up",
  //   value: store.$state.storeCounts.backup_only_7d,
  //   bgColor: "bg-info",
  //   routeValue: "",
  //   tableType: "backup_only_7d",
  // });
  // // Store Health Status
  // storeStatus.value.push({
  //   title: "Down 0%",
  //   value: store.$state.storeCounts.problematicStores0_7d,
  //   bgColor: "bg-info",
  //   routeValue: "",
  //   tableType: "problematic0_7d",
  // });
  // storeStatus.value.push({
  //   title: "Up Problematic > 0% but 95%",
  //   value: store.$state.storeCounts.problematicStoresLess95_7d,
  //   bgColor: "bg-info",
  //   routeValue: "",
  //   tableType: "problematic95_7d",
  // });
  // storeStatus.value.push({
  //   title: "Up Healthy >= 95% But < 100%",
  //   value: store.$state.storeCounts.store_healthy_7d,
  //   bgColor: "bg-info",
  //   routeValue: "",
  //   tableType: "store_healthy_7d",
  // });
  // storeStatus.value.push({
  //   title: "Up Excellent 100%",
  //   value: store.$state.storeCounts.store100_7d,
  //   bgColor: "bg-info",
  //   routeValue: "",
  //   tableType: "store100_7d",
  // });
};

// STORE MAP DATA ------------------------------------------------
const initializeMap = async () => {
  const map = L.map("map-down").setView([12.988, 121.774], 6);

  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    attribution:
      '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
  }).addTo(map);

  const redMarkerIcon = L.icon({
    iconUrl: redPin,
    iconSize: [25, 41],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
    shadowSize: [41, 41],
  });
  const softYellowMarkerIcon = L.icon({
    iconUrl: softYellowPin,
    iconSize: [25, 41],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
    shadowSize: [41, 41],
  });
  const yellowMarkerIcon = L.icon({
    iconUrl: yellowPin,
    iconSize: [25, 41],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
    shadowSize: [41, 41],
  });

  const darkRedMarkerIcon = L.icon({
    iconUrl: darkRedPin,
    iconSize: [25, 41],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
    shadowSize: [41, 41],
  });

  const orangeMarkerIcon = L.icon({
    iconUrl: orangePin,
    iconSize: [25, 41],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
    shadowSize: [41, 41],
  });

  rows.value.forEach((row) => {
    if (row.latitude !== 0 && row.longitude !== 0) {
      // const zabbixDownTimestamp = new Date(row.zabbix_down_duration);
      // const currentTime = new Date();
      // const durationInMs = currentTime - zabbixDownTimestamp;
      // const durationInDays = durationInMs / (1000 * 60 * 60 * 24);
      const zabbixDownTimestamp = new Date(row.zabbix_down_duration).getTime();
      const currentTime = Date.now();
      const durationInMs = currentTime - zabbixDownTimestamp;
      const durationInDays = durationInMs / (1000 * 60 * 60 * 24);

      if (durationInDays < 1) {
        L.marker([row.latitude, row.longitude], { icon: yellowMarkerIcon })
          .addTo(map)
          .bindPopup(`<b>Site ID:</b> ${row.site_id}`);
      } else if (durationInDays < 3) {
        L.marker([row.latitude, row.longitude], { icon: orangeMarkerIcon })
          .addTo(map)
          .bindPopup(`<b>Site ID:</b> ${row.site_id}`);
      } else if (durationInDays < 7) {
        L.marker([row.latitude, row.longitude], { icon: redMarkerIcon })
          .addTo(map)
          .bindPopup(`<b>Site ID:</b> ${row.site_id}`);
      } else if (durationInDays > 7) {
        L.marker([row.latitude, row.longitude], { icon: darkRedMarkerIcon })
          .addTo(map)
          .bindPopup(`<b>Site ID:</b> ${row.site_id}`);
      } else {
        L.marker([row.latitude, row.longitude], { icon: softYellowMarkerIcon })
          .addTo(map)
          .bindPopup(`<b>Site ID:</b> ${row.site_id}`);
      }
    }
  });
};
// STORE MAP DATA ------------------------------------------------

// GRAFANA  ------------------------------------------------

const generateUrl = () => {
  return `https://grafana.apolloglobal.net/d-solo/h2GD6-DIk/store-count-history?orgId=1&from=now-${timeSelected.value}&to=now&panelId=4&theme=${theme.value}`;
};
const theme = ref("light");

// GRAFANA  ------------------------------------------------

const extractDataCSV = async () => {
  console.log("Downloading csv");

  try {
    $q.loading.show();
    const response = await extractCSV();
    const blob = new Blob([response.data], {
      type: response.headers["content-type"],
    });
    const link = document.createElement("a");
    link.href = window.URL.createObjectURL(blob);
    link.download = "output.csv";
    link.click();
  } catch (error) {
    $q.loading.hide();
  }
  $q.loading.hide();
};
const extractStoreCSV = async () => {
  console.log("Downloading Store data csv");
  try {
    $q.loading.show();
    const response = await extractStoreDataCSV();
    const blob = new Blob([response.data], {
      type: response.headers["content-type"],
    });
    const link = document.createElement("a");
    link.href = window.URL.createObjectURL(blob);
    link.download = "store-data.csv";
    link.click();
  } catch (error) {
    $q.loading.hide();
  }
  $q.loading.hide();
};

const refresh = () => {
  $q.loadingBar.start();
  try {
    store.$state.storeCounts = {} as IcountAllStore;
    allStores.value = [];
    totalDownStores.value = [];
    problematicStores.value = [];
    primaryCircuit.value = [];
    backupCircuit.value = [];
    storeConnectivity.value = [];
    storeStatus.value = [];
    rows.value = [];

    setProblematicCircuits();
    getDownStores();
  } catch (error) {
    console.log(error);
    $q.notify({
      message: "Could not refresh count data!",
      color: "negative",
    });
  } finally {
    $q.loadingBar.stop();
  }
};
const getCounts = () => {
  $q.loading.show({
    message: "Gathering Data for Counts...",
  });
  store.$state.storeCounts = {} as IcountAllStore;
  allStores.value = [];
  totalDownStores.value = [];
  problematicStores.value = [];
  primaryCircuit.value = [];
  backupCircuit.value = [];
  storeConnectivity.value = [];
  storeStatus.value = [];
  rows.value = [];
  try {
    setProblematicCircuits();
    getDownStores();
  } catch {
    $q.loading.hide();
    $q.notify({
      message: "Could not retrieve count data!",
      color: "negative",
    });
  }
  $q.loading.hide();
};

setTimeout(() => {
  refresh();
}, 300000);
onMounted(async () => {
  // getDownStores();

  $q.loading.show({
    message: "Gathering Data for Counts...",
  });
  allStores.value = [];
  totalDownStores.value = [];
  problematicStores.value = [];
  primaryCircuit.value = [];
  backupCircuit.value = [];
  storeConnectivity.value = [];
  storeStatus.value = [];
  rows.value = [];
  try {
    //await getZabbixDownStoresCount();
    await setProblematicCircuits();
    await getDownStores();
  } catch {
    $q.loading.hide();
    $q.notify({
      message: "Could not retrieve count data!",
      color: "negative",
    });
  }
  $q.loading.hide();
});

// const client = new Client({
//   brokerURL: "ws://localhost:7500/ws",
//   onConnect: () => {
//     client.subscribe("/topic/storeCounts", (message) =>
//       console.log(`Received: ${message.body}`)
//     );
//     client.publish({
//       destination: "/topic/storeCounts",
//       body: "First Message",
//     });
//   },
// });

// client.activate();
</script>
<style scoped>
.csv-buttons {
  display: flex;
  flex-wrap: wrap;
  max-width: 500px;
  gap: 0.5em;
}

.refresh-btn {
  position: absolute;
  top: 0;
  right: 0;
  margin: 5px 5px 0 0;
  z-index: 50;
}
.iframe-card {
  max-width: 1920px;
  margin: 0 auto;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%; /* Ensure the card takes the full height */
}

.history-graph-container {
  max-width: 100%;
  width: 100%;
}

.history-graph-container > iframe {
  width: 100%;
  max-width: 11000px; /* Adjust the max-width as needed */
  height: 400px; /* Adjust the height as needed */
}
</style>
