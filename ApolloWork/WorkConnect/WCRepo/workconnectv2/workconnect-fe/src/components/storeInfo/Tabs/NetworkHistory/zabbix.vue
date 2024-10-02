<template>
  <div style="display: flex; gap: 0.75em">
    <div style="max-width: 300px">
      <q-input filled v-model="zabbixDateInput" dense>
        <template v-slot:append>
          <q-icon name="event" class="cursor-pointer">
            <q-popup-proxy
              cover
              transition-show="scale"
              transition-hide="scale"
              ref="proxy"
            >
              <!-- <q-date
                v-model="zabbixDate"
                default-view="Years"
                emit-immediately
                minimal
                mask="YYYY/MM"
                @update:model-value="onUpdateVal"
                class="myDate"
                ref="monthPicker"
              >
                <div class="row items-center justify-end">
                  <q-btn v-close-popup label="Close" color="primary" flat />
                </div>
              </q-date> -->
              <q-date v-model="zabbixDate" range @range-end="getZabbixVal">
                <div class="row items-center justify-end">
                  <!-- <q-btn
                    v-close-popup
                    label="Get Report"
                    color="primary"
                    flat
                    @click="getZabbixVal"
                  /> -->
                </div>
              </q-date>
            </q-popup-proxy>
          </q-icon>
          <!-- <q-btn
            icon="send"
            class="zabbix-btn"
            flat
            size="sm"
            round
            @click="getZabbixVal"
          /> -->
        </template>
      </q-input>

      <!-- <span> {{ monthName + " " + year }}</span> -->
    </div>
    <q-btn v-if="hasPermission('ROLE_GENERATE_REPORTS')" @click="getCSVZabbix"
      >Zabbix Report {{ siteId }}</q-btn
    >
    <!-- <q-btn
      v-if="hasPermission('ROLE_GENERATE_REPORTS')"
      @click="getAllCSVZabbix"
      >Zabbix Report Stores</q-btn
    > -->
  </div>
  <div class="zabbix-info">
    <zabbix-card
      :circuit-type="'Store'"
      :ip="storeDetails?.vip_ip"
      :status="storeDetails?.vip"
      :events="storeDetails?.vip_events"
      :last-changed="storeDetails?.vip_lastchange"
    ></zabbix-card>

    <zabbix-card
      :circuit-type="'Primary'"
      :ip="primaryDetails?.primary_ip"
      :status="primaryDetails?.primary"
      :events="primaryDetails?.primary_events"
      :last-changed="primaryDetails?.primary_lastchange"
    ></zabbix-card>
    <zabbix-card
      :circuit-type="'Backup'"
      :ip="backupDetails?.backup_ip"
      :status="backupDetails?.backup"
      :events="backupDetails?.backup_events"
      :last-changed="backupDetails?.backup_lastchange"
    ></zabbix-card>
  </div>
  <q-dialog v-model="zabbixReportModal">
    <table-zabbix :rows="rowZabbix" :close-btn="true"></table-zabbix>
  </q-dialog>
</template>

<script setup lang="ts">
import { onMounted, ref, watch } from "vue";
import { getZabbixCircuitDetails, getZabbixCircuitReport } from "src/api/api";
import {
  zabbixPrimary,
  zabbixStore,
  zabbixBackup,
  zabbixEvents,
} from "src/api/types";
import { useQuasar } from "quasar";
import zabbixCard from "src/components/cards/zabbixCard.vue";
import TableZabbix from "src/components/tables/TableZabbix.vue";
import moment from "moment";

const props = defineProps<{
  siteId: string;
}>();
const $q = useQuasar();
const currentDate = new Date();
const currentYear = currentDate.getFullYear();
const currentMonth = (currentDate.getMonth() + 1).toLocaleString("en-US", {
  minimumIntegerDigits: 2,
});
const dateNow = new Date();
// const zabbixDate = ref(`${currentYear}/${currentMonth}`);
const zabbixDate = ref<{ from: string; to: string }>({
  from: moment().subtract(1, "months").format("YYYY/MM/DD"),
  to: moment().format("YYYY/MM/DD"),
});
const zabbixDateInput = ref(
  zabbixDate.value.from + " - " + zabbixDate.value.to
);
const proxy = ref({
  hide: () => {},
});
const zabbixReportModal = ref(false);
const rowZabbix = ref<any[]>([]);
const currentView = ref("Years");
const monthPicker = ref<any>("");
const storeDetails = ref<zabbixStore>();
const primaryDetails = ref<zabbixPrimary>();
const backupDetails = ref<zabbixBackup>();
const onUpdateVal = () => {
  currentView.value = currentView.value === "Years" ? "Months" : "Years";
  monthPicker.value.setView(currentView.value);
};

import { auth } from "src/stores/auth";
import { storeToRefs } from "pinia";

const auths = auth();
const {
  keycloak,
  getName,
}: {
  keycloak: any;
  getName: any;
} = storeToRefs(auths);
const hasPermission = (authority: String) => {
  if (keycloak.value.realmAccess.roles.includes(authority)) {
    console.log("keycloak", true);
    return true;
  }
  return false;
};

const getCSVZabbix = async () => {
  const from = zabbixDate.value.from.split("/").join("-");
  const to = zabbixDate.value.to.split("/").join("-");
  try {
    $q.loading.show({
      message: "Gathering Zabbix report for " + props.siteId,
    });
    rowZabbix.value = await getZabbixCircuitReport(props.siteId, from, to);
    if (rowZabbix.value.length > 0) {
      zabbixReportModal.value = true;
    } else {
      $q.notify({
        message: "No Down Events Found for " + props.siteId,
        color: "primary",
      });
    }
  } catch (error) {
    $q.loading.hide();
    console.error("Fetch error:", error);
  }
  $q.loading.hide();
};

const getZabbixVal = async () => {
  storeDetails.value = {} as zabbixStore;
  primaryDetails.value = {} as zabbixPrimary;
  backupDetails.value = {} as zabbixBackup;
  const from = zabbixDate.value.from.split("/").join("-");
  const to = zabbixDate.value.to.split("/").join("-");
  proxy.value.hide();
  console.log(props.siteId + " " + from + " " + to);
  try {
    $q.loading.show();
    const zabbixResponse = await getZabbixCircuitDetails(
      props.siteId,
      from,
      to
    );
    if (zabbixResponse[0]) {
      storeDetails.value = zabbixResponse[0];
    }
    if (zabbixResponse[1]) {
      primaryDetails.value = zabbixResponse[1];
    }
    if (zabbixResponse[2]) {
      backupDetails.value = zabbixResponse[2];
    }
  } catch (error) {
    console.log(error);
    $q.loading.hide();
  }
  $q.loading.hide();
};

onMounted(() => {
  getZabbixVal();
});
watch(
  () => zabbixDate.value,
  (newVal, oldVal) => {
    zabbixDateInput.value = newVal.from + "-" + newVal.to;
  }
);
</script>

<style scoped>
.zabbixBtn {
  cursor: pointer;
}
.zabbix-info {
  display: grid;
  grid-template-columns: 1fr;
  gap: 0.75em;
}
.q-dialog__inner--minimized > div {
  max-width: 1200px;
}
@media screen and (min-width: 700px) {
  .zabbix-info {
    grid-template-columns: 1fr 1fr 1fr;
  }
}
</style>
