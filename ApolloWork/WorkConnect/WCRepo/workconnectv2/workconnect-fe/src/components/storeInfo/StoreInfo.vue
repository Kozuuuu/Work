<template>
  <!-- <q-btn
    v-if="currentRoute"
    icon="arrow_back"
    to="/Stores"
    flat
    rounded
    class="back_arrow_store"
    >Back</q-btn
  > -->

  <q-card class="main-card" v-if="detailsRetrieved">
    <q-card-section>
      <q-tabs
        v-model="tabs"
        dense
        class="bg-primary text-white sticky_class"
        :style="
          route.path.match(/\/Stores\/ST-(\d+)/) ? 'top: 73px' : 'top:0px'
        "
        active-color="dark"
        indicator-color="dark"
        @click="handleTabChange"
        align="justify"
      >
        <div class="text-bold q-px-sm search-store" @click="storeDialog = true">
          {{ toUseSiteId }} <q-icon name="search"></q-icon>
          <q-tooltip> Search Other Store </q-tooltip>
        </div>
        <q-dialog v-model="storeDialog">
          <q-card class="q-pa-sm">
            <q-card-section style="display: flex">
              <q-form @submit="searchStore(storeSearch)">
                <q-input
                  v-model="storeSearch"
                  dense
                  outlined
                  style="max-width: 300px"
                  label="Search Store"
                  mask="ST-XXXX"
                >
                  <template v-slot:append>
                    <q-btn
                      icon="search"
                      class="cursor-pointer"
                      @click="searchStore(storeSearch)"
                      type="submit"
                      flat
                      rounded
                    >
                    </q-btn>
                  </template>
                </q-input>
              </q-form>
              <q-btn
                icon="close"
                size="sm"
                class="clickable"
                rounded
                flat
                v-close-popup
              ></q-btn>
            </q-card-section>
          </q-card>
        </q-dialog>

        <q-tab name="siteInfo" label="Store Info" />

        <q-tab name="map-tab" label="Store Map" @click="handleTabChange" />
        <q-tab name="networkHistory" label="Network History" />
        <q-tab
          v-if="hasPermission(['ROLE_AUTO_DISCOVERY'])"
          name="parse"
          label="Auto-Discover"
        />
        <!-- <q-tab name="rt" label="RT" /> -->
        <q-tab
          v-if="hasPermission(['ROLE_GENERATE_REPORTS', 'GROUP_PSC_USERS'])"
          name="rt"
          label="RT"
        />
        <q-tab
          name="circuit-log"
          label="Circuit Log"
          v-if="hasPermission(['ROLE_ACTIVITY_LOG'])"
        />
        <q-tab
          v-if="hasPermission(['ROLE_ACTIVITY_LOG'])"
          name="activity_log"
          label="Activity Log"
        />
        <q-tab
          v-if="hasPermission(['ROLE_CLIQQ_REPORTS'])"
          name="cliqq"
          label="Cliqq Wifi Report"
        />
        <q-btn icon="close" flat dense v-close-popup v-if="!currentRoute" />
      </q-tabs>

      <q-separator />

      <q-tab-panels v-model="tabs" animated>
        <q-tab-panel name="siteInfo">
          <div class="site__infos">
            <div
              v-for="(section, sectionTitle) in profileSections"
              :key="sectionTitle"
            >
              <q-card-section class="prom-info border-box">
                <span class="text-h6 text-bold text-uppercase">{{
                  sectionTitle
                }}</span>
                <p v-for="(value, key) in section" :key="key">
                  {{ formatString(key) }}:
                  <span
                    class="text-bold"
                    v-if="value !== undefined && value !== null"
                  >
                    <br />
                    {{ value }}
                  </span>
                </p>
              </q-card-section>
            </div>
          </div>
          <q-card-section
            v-if="
              hasPermission([
                'GROUP_APOLLO_PROD_SUPPORT',
                'GROUP_APOLLO_OPERATIONS',
                'GROUP_PSC_USERS',
              ])
            "
          >
            <q-table
              :title="`Circuit Info: ${toUseSiteId} - ${storeProfile?.router}`"
              :rows="rowsCircuitInfo"
              row-key="Circuit"
              separator="cell"
              class="border-box q-mt-md"
              :pagination="{
                rowsPerPage: 10,
              }"
              hide-bottom
            >
              <!-- <template #top-right="props">
                <div>
                  {{
                    storeProfile?.serial_number
                      ? `SN: ${storeProfile?.serial_number}`
                      : ""
                  }}
                </div>
              </template> -->
            </q-table>
          </q-card-section>
          <q-card-section>
            <q-table
              :rows="rowsDevices"
              :columns="deviceColumn"
              separator="cell"
              class="border-box q-mt-md"
              :pagination="{
                rowsPerPage: 10,
                sortBy: 'name',
                descending: false,
              }"
              hide-bottom
            >
              <template #top-left>
                <div class="text-h6">
                  Devices
                  <span class="text-caption">Netbox</span>
                </div>
              </template>
            </q-table>
          </q-card-section>
          <q-card-section>
            <q-table
              :rows="rowsAssets"
              :columns="assetsColumn"
              separator="cell"
              class="border-box q-mt-md"
              :pagination="{
                rowsPerPage: 10,
                sortBy: 'name',
                descending: false,
              }"
              hide-bottom
            >
              <template #top-left>
                <div class="text-h6">
                  Assets
                  <span class="text-caption">atis</span>
                </div>
              </template>
            </q-table>
          </q-card-section>
        </q-tab-panel>
        <q-tab-panel name="networkHistory" class="q-tab-panel-network-history">
          <q-tabs
            v-model="tab"
            dense
            class="text-dark"
            active-color="primary"
            indicator-color="primary"
            align="justify"
            narrow-indicator
          >
            <q-tab name="prometheus" label="Prometheus" />
            <q-tab name="SNMP" label="Traffic" />
            <q-tab name="zabbix" label="Zabbix" />
          </q-tabs>

          <q-select
            v-if="tab !== 'zabbix'"
            v-model="timeSelected"
            bordered
            :options="timeOptions"
            filled
            dense
            emit-value
            map-options
            style="width: 250px"
            class="q-ma-md q-mb-none"
          />

          <q-tab-panels v-model="tab">
            <q-tab-panel name="prometheus" class="q-pt-none">
              <iframe
                :src="`${grafanaUrl}/d-solo/FMHV4pVnk/site-info?orgId=1&refresh=5s&from=now-${timeSelected}&to=now&panelId=41&var-Devices=${toUseSiteId}`"
                class="prometheus-grafana"
                frameborder="0"
              ></iframe>
            </q-tab-panel>
            <q-tab-panel name="SNMP" class="q-pt-none">
              <div class="traffic-graph">
                <iframe
                  :src="`${grafanaUrl}/d-solo/FMHV4pVnk/site-info?orgId=1&refresh=5s&from=now-${timeSelected}&to=now&panelId=16&var-Devices=${toUseSiteId}`"
                  frameborder="0"
                  class="traffic-graph-item"
                ></iframe>
                <iframe
                  :src="`${grafanaUrl}/d-solo/FMHV4pVnk/site-info?orgId=1&refresh=5s&from=now-${timeSelected}&to=now&panelId=37&var-Devices=${toUseSiteId}`"
                  frameborder="0"
                  class="traffic-graph-item"
                ></iframe>
              </div>
            </q-tab-panel>
            <q-tab-panel name="zabbix" class="q-pt-none">
              <zabbix :site-id="toUseSiteId"></zabbix
            ></q-tab-panel>
          </q-tab-panels>
        </q-tab-panel>
        <q-tab-panel name="parse">
          <auto-discover
            :store-id="toUseSiteId"
            :circuitInfo="circuitInfos"
          ></auto-discover>
        </q-tab-panel>
        <q-tab-panel name="map-tab">
          <q-card>
            <!-- TODO: add maps here -->
            <div id="map" style="height: 500px"></div>
          </q-card>
        </q-tab-panel>
        <q-tab-panel name="rt">
          <ticket :site-id="toUseSiteId"></ticket>
        </q-tab-panel>
        <q-tab-panel name="circuit-log">
          <circuit-logs-by-site-id
            :store-id="toUseSiteId"
            :router="storeRouter"
          ></circuit-logs-by-site-id>
        </q-tab-panel>
        <q-tab-panel name="activity_log">
          <activity-log :site-id="toUseSiteId"></activity-log>
        </q-tab-panel>
        <q-tab-panel name="cliqq">
          <Cliqq :store-id="toUseSiteId"></Cliqq>
        </q-tab-panel>
      </q-tab-panels>
      <!-- <q-tab-panels v-model="tabs"> </q-tab-panels> -->
    </q-card-section>
  </q-card>
</template>

<script setup lang="ts">
import L from "leaflet";
import "leaflet/dist/leaflet.css";
import { onMounted, ref, computed, watchEffect } from "vue";
import {
  IstoreProfile,
  macAndGateway,
  publicIpAndProvider,
  IcircuitInfo,
  IassetsStoreInfo,
  IdevicesNetboxData,
} from "src/api/types";
import { useSiteStore } from "src/stores/sites/stores";
import {
  getStoreProfile,
  getStoreProfileAdditional,
  getMacAndGateway,
  getAtisAssets,
  getDevicesNetbox,
} from "src/api/api";
import { useRoute, useRouter } from "vue-router";
import { QTableColumn, QTableProps, useQuasar } from "quasar";

import AutoDiscover from "./Tabs/AutoDiscover.vue";
import zabbix from "src/components/storeInfo/Tabs/NetworkHistory/zabbix.vue";
import ticket from "src/components/storeInfo/Tabs/RequestTracker/RT.vue";
import CircuitLogsBySiteId from "src/components/storeInfo/Tabs/CircuitLogsByStore.vue";
import Cliqq from "src/components/storeInfo/Tabs/Cliqq/Cliqq.vue";
import ActivityLog from "./Tabs/ActivityLogs/ActivityLog.vue";
import redPin from "/red-pin2.png";
import { hasPermission } from "src/utils/helper";
const $q = useQuasar();
const grafanaUrl = "https://grafana.apolloglobal.net";

const timeSelected = ref("7d");
const store = useSiteStore();
const tabs = ref("siteInfo");
const tab = ref("prometheus");

const storeProfile = ref<IstoreProfile>();
const circuitInfos = ref<IcircuitInfo>();
const rowsDevices = ref<IdevicesNetboxData[]>();
const rowsAssets = ref<IassetsStoreInfo[]>();
const rowsCircuitInfo = ref<
  {
    Circuit: string | undefined;
    Store: string | undefined;
    Primary: string | undefined;
    Backup: string | undefined;
    Third?: string | undefined;
  }[]
>([]);
const storeSearch = ref("");
const storeDialog = ref(false);
const toUseSiteId = ref("");
const storeRouter = ref("");
const route = useRoute();
const router = useRouter();
const detailsRetrieved = ref(false);
const timeOptions = [
  { label: "Last 5 minutes", value: "5m" },
  { label: "Last 15 minutes", value: "15m" },
  { label: "Last 30 minutes", value: "30m" },
  { label: "Last 1 hour", value: "1h" },
  { label: "Last 3 hours", value: "3h" },
  { label: "Last 6 hours", value: "6h" },
  { label: "Last 12 hours", value: "12h" },
  { label: "Last 24 hours", value: "24h" },
  { label: "Last 2 days", value: "2d" },
  { label: "Last 7 days", value: "7d" },
  { label: "Last 90 days", value: "90d" },
];

// import { auth } from "src/stores/auth";
// import { storeToRefs } from "pinia";

// const auths = auth();
// const { keycloak, getName } = storeToRefs(auths);
// const hasPermission = (authority: String) => {
//   // @ts-ignore
//   if (keycloak.value.realmAccess.roles.includes(authority)) {
//     console.log("keycloak", true);
//     return true;
//   }
//   return false;
// };

const profileSections = computed(() => ({
  "Basic Info": {
    id: storeProfile.value?.id,
    site_id: storeProfile.value?.site_id,
    name: storeProfile.value?.name,
    contact_person: storeProfile.value?.contact_person,
    contact_nos: storeProfile.value?.contact_nos,
    tenant_name: storeProfile.value?.tenant_name,
  },
  "Location Info": {
    island_group: storeProfile.value?.island_group,
    address: storeProfile.value?.address,
    zipcode: storeProfile.value?.zipcode,
    region: storeProfile.value?.region,
    // status: storeProfile.value?.status,
    latitude: storeProfile.value?.latitude,
    longitude: storeProfile.value?.longitude,
  },
}));

// STORE MAP RELATED -------------------------------
const mapInitialized = ref(false);
const initMap = () => {
  const mapContainer = document.getElementById("map");
  const { latitude, longitude } = storeProfile.value || {};

  if (mapContainer && latitude && longitude) {
    const map = L.map(mapContainer).setView([latitude, longitude], 15);

    console.log("Map should be showing");
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: "&copy; OpenStreetMap contributors",
    }).addTo(map);

    const markerIcon = L.icon({
      iconUrl: redPin,
      iconSize: [25, 41],
      iconAnchor: [12, 41],
      popupAnchor: [1, -34],
      shadowSize: [41, 41],
    });

    L.marker([latitude, longitude], { icon: markerIcon })
      .addTo(map)
      .bindPopup("Store Location")
      .openPopup();

    mapInitialized.value = true;
  }
};
const searchStore = async (storeId: string) => {
  await router.push("/Stores");
  await router.push("/Stores/" + storeId);
};
const handleTabChange = (panelName: String) => {
  // console.log("tabchange");
  initMap();
};
// STORE MAP RELATED -------------------------------

const formatString = (inputString: string) => {
  return inputString
    .split("_") // Split the string into an array using underscores as separators
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
    .join(" "); // Join the array back into a string with spaces
};

const isNoData = (value: number | undefined): string => {
  return value === -1 ? "NO DATA" : (Number(value) * 100).toFixed(0) + "%";
};

const currentRoute: string = Array.isArray(route.params.storeId)
  ? route.params.storeId[0] // Assuming you want the first element if it's an array
  : route.params.storeId;

const getDetailsOfStore = async () => {
  try {
    $q.loading.show({
      message: "Gathering Store Details...",
    });

    const siteIdToUse = store.$state.selectedStoreId || currentRoute;
    toUseSiteId.value = siteIdToUse;
    const storeDetailsAdditional = await getStoreProfileAdditional(siteIdToUse);
    const storeDetails = await getStoreProfile(siteIdToUse);
    rowsAssets.value = await getAtisAssets(siteIdToUse);
    const resDevices = await getDevicesNetbox(siteIdToUse);
    rowsDevices.value = resDevices.data;

    storeRouter.value = storeDetails.router;
    storeProfile.value = { ...storeDetails, ...storeDetailsAdditional };
    const {
      mac_primary,
      mac_backup,
      mac_third,
      gtw_primary,
      gtw_backup,
      gtw_third,
      public_ip_primary,
      public_ip_backup,
      public_ip_third,
      provider_primary,
      provider_backup,
      backup_third,
      provider_third,
    } = storeProfile.value;
    circuitInfos.value = {
      mac_primary,
      mac_backup,
      mac_third,
      gtw_primary,
      gtw_backup,
      gtw_third,
      public_ip_primary,
      public_ip_backup,
      public_ip_third,
      provider_primary,
      provider_backup,
      backup_third,
      provider_third,
    };
    $q.loading.hide();
    detailsRetrieved.value = true;
  } catch (error) {
    console.log(error);

    if (route.path.match(/\/Stores\/ST-(\d+)/)) {
      router.push("/Stores");
    }
    $q.loading.hide();
    $q.notify({
      message: "Could not Retrieve Store Details!",
      color: "warning",
      position: "top",
    });
  }
  $q.loading.hide();
};
const assetsColumn = [
  {
    name: "name",
    align: "left",
    label: "Name",
    field: "name",
    sortable: true,
  },
  {
    name: "serial_number",
    align: "left",
    label: "Serial Number",
    field: "serial_number",
    sortable: true,
  },
  {
    name: "property_code",
    align: "left",
    label: "Property Code",
    field: "property_code",
    sortable: true,
  },
  {
    name: "equipment_code",
    align: "left",
    label: "Equipment Code",
    field: "equipment_code",
    sortable: true,
  },
  {
    name: "condition",
    align: "left",
    label: "Condition",
    field: "condition",
  },
  {
    name: "status",
    align: "left",
    label: "Status",
    field: "status",
  },
] as QTableProps["columns"];

const deviceColumn = [
  {
    name: "name",
    align: "left",
    label: "Name",
    field: "name",
    sortable: true,
  },
  {
    name: "status",
    align: "left",
    label: "Status",
    field: (row) => row.status.value,
    sortable: true,
  },
  {
    name: "serial",
    align: "left",
    label: "Serial Number",
    field: "serial",
    sortable: true,
  },
  {
    name: "device_role",
    align: "left",
    label: "Role",
    field: (row) => row.device_role.name,
    sortable: true,
  },
  {
    name: "device_type",
    align: "left",
    label: "Manufacturer",
    field: (row) => row.device_type.manufacturer.name,
  },
  {
    name: "status",
    align: "left",
    label: "Type",
    field: (row) => row.device_type.model,
  },
] as QTableProps["columns"];

watchEffect(() => {});
onMounted(async () => {
  await getDetailsOfStore();

  rowsCircuitInfo.value = [
    {
      Circuit: "Uptime Availability 7 days",
      Store: isNoData(storeProfile.value?.loopback_0),
      Primary: isNoData(storeProfile.value?.loopback_1),
      Backup: isNoData(storeProfile.value?.loopback_2),
    },
    {
      Circuit: "Uptime Availability 24 hours",
      Store: isNoData(storeProfile.value?.loopback_0_24h),
      Primary: isNoData(storeProfile.value?.loopback_1_24h),
      Backup: isNoData(storeProfile.value?.loopback_2_24h),
    },
    {
      Circuit: "Loopback Ip",
      Store: storeProfile.value?.lo0,
      Primary: storeProfile.value?.lo1,
      Backup: storeProfile.value?.lo2,
    },
    {
      Circuit: "Circuit Provider",
      Store: "",
      Primary: storeProfile.value?.provider_primary,
      Backup: storeProfile.value?.provider_backup,
    },
    // {
    //   Circuit: "Circuit Status",
    //   Store: "",
    //   Primary: storeProfile.value?.primary_circuit_status,
    //   Backup: storeProfile.value?.backup_circuit_status,
    // },
  ];
  if (storeProfile.value?.router.toLowerCase() === "ruijie") {
    rowsCircuitInfo.value[0].Third = isNoData(storeProfile.value?.loopback_3);
    rowsCircuitInfo.value[1].Third = isNoData(
      storeProfile.value?.loopback_3_24h
    );
    rowsCircuitInfo.value[2].Third = storeProfile.value?.lo3;
    rowsCircuitInfo.value[3].Third = storeProfile.value?.provider_third;
  }
  store.$state.selectedStoreId = "";
});
// onMounted(async () => {
//   const storeDetailsAdditional = await getStoreProfileAdditional(currentRoute);
//   const storeDetails = await getStoreProfile(currentRoute);
//   storeProfile.value = { ...storeDetails, ...storeDetailsAdditional };

// });
</script>

<style scoped>
.main-card {
  margin: 0 auto;
  max-width: 1800px;
  min-height: 300px;
}
.myDate > .row ~ .row {
  display: none !important;
}

.site__infos {
  display: grid;
  grid-gap: 1em;
  text-align: center;
  /* font-size: 0.75rem; */
}

.site__infos-child {
  flex: 1;
  min-width: 200px;
}

.q-tab-panel-network-history {
  padding: 0;
}

.q-card__section--vert {
  padding: 0;
}

.prometheus-grafana {
  width: 100%;
  aspect-ratio: 1/1;
}

.prom-info {
  height: 100%;
  border-radius: 5px;
  padding-top: 10px;
  padding-right: 10px;
  padding-left: 10px;
}

.border-box {
  border: 1px solid black;
  box-shadow: rgba(0, 0, 0, 0.16) 0px 3px 6px, rgba(0, 0, 0, 0.23) 0px 3px 6px;
}

.traffic-graph {
  display: grid;
  gap: 0.5em;
}

.traffic-graph-item {
  width: 100%;
  aspect-ratio: 21/14;
}

.back_arrow_store {
  position: absolute;
  top: 0;
  left: 0;
  margin: 5px 5px 0 0;
  z-index: 50;
}

@media screen and (min-width: 700px) {
  .site__infos {
    display: grid;
    grid-template-columns: 1fr 1fr;
    grid-gap: 1em;
    text-align: center;
  }

  .site__infos-child {
    flex: 1;
    min-width: 200px;
  }

  .traffic-graph {
    display: flex;
    gap: 0.5em;
  }

  .prometheus-grafana {
    aspect-ratio: 21 / 7;
  }
}
.sticky_class {
  position: sticky;
  z-index: 50;
}
.search-store:hover {
  cursor: pointer;
  color: black;
  transform: scale(1.05);
  transition: transform 0.5s ease;
}
</style>
