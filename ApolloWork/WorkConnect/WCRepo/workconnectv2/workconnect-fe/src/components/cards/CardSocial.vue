<template>
  <q-card class="q-mb-md" flat>
    <q-card-section class="">
      <q-item-label class="text-h6 q-mb-sm">
        <span> {{ title }}</span>
        <q-space />
        <span v-if="date_timestamp" class="text-subtitle1"
          >Last Updated Date: {{ date_timestamp }}</span
        >
        <q-separator />
      </q-item-label>
      <div class="card-container">
        <div class="container">
        <div
          v-for="item in prop_items"
          :key="item.bgColor"
          :class="`${item.bigSize ? 'big-card' : 'small-card'}`"
          :style="{ flex: `1 1 ${item.percentage}%`}"
        >
          <q-item
            
            :class="`
              ${item.tableType ? 'child-container-list ' : 'child-container'} ${
              item.bgColor
            }`"
            :style="{height:'90px' }"
          >
            <q-item-section
              class="text-white q-item-class"
              @click="handleOpenList(item.tableType, item.title)"
            >
              <q-item-label class="text-white text-weight-bolder">{{
                item.value
              }}</q-item-label>

              <!-- <q-item-label>{{ `${item.title}` }}</q-item-label> -->
            </q-item-section>
            <!-- <q-icon
              v-if="item.listValue && item.listValue.length > 0"
              name="list"
              @click="openFirstModal = !openFirstModal"
              size="sm"
              color="info"
            /> -->
          </q-item>
        </div>
      </div>
      </div>
      <div v-if="title === 'Store Connectivity 7 days' || title === 'Store Connectivity 24 hours'">
        <card-legends
          class="legends"
          labelOne="Dual Circuit"
          labelTwo="Primary Only"
          labelThree="Backup Only"
          labelFour="Third Up"
        />
      </div>
      <div v-else-if="title === 'Store Health Status 7 days' || title === 'Store Health Status 24 hours'">
        <card-legends
          class="second-card-legends" 
          labelOne="Excellent"
          labelTwo="Up Healthy >= 95% but 100%"
          labelThree="Up Problematic > 0% but 95%"
          labelFour="Down 0%"
          :containerWidth="'700px'"
        />
      </div>
      <div v-else-if="title === 'Mindanao'">
        <card-legends
          class="mindanao-card-legends" 
          labelOne="All Mindanao Stores"
          labelTwo="Down Stores"
          :containerWidth="'700px'"
        />
      </div>
    </q-card-section>
  </q-card>
  <q-dialog v-model="openFirstModal">
    <q-card class="card-dialog">
      <q-card-section class="row q-py-none q-card-section-align">
      </q-card-section>

      <q-card-section class="q-pa-none">
        <table-store-details
          v-if="tableLayout === 'storeDetails'"
          :title="currentTitle"
          :rows="rowDetails"
          :close-btn="true"
          :card-title="props.title"
          :loopback-val="'duration'"
        ></table-store-details>
        <table-provider-circuit
          v-if="tableLayout === 'circuitDetails'"
          :title="currentTitle"
          :rows="rowDetails"
          :close-btn="true"
          :card-title="props.title"
          :loopback-val="'uptime'"
        >
        </table-provider-circuit>
      </q-card-section>
    </q-card>
  </q-dialog>

  <!-- <q-dialog
    v-model="secondDialog"
    transition-show="scale"
    transition-hide="scale"
  >
    <q-card class="" style="width: 300px">
      <q-card-section>
        <div class="text-h6">{{ siteDetails.siteId }}</div>
      </q-card-section>

      <q-card-section class="q-pt-none">
        <div class="flex">
          <div>store description</div>
          <div>lo0 uptime availability 24hrs: {{ siteDetails.loopback0 }}</div>
          <div>lo1 uptime availability 24hrs: {{ siteDetails.loopback1 }}</div>
          <div>
            primary circuit provider: {{ siteDetails.primaryCircuitProvider }}
          </div>
          <div>primary circuit status</div>
          <div>lo2 uptime availability 24hrs: {{ siteDetails.loopback2 }}</div>
          <div>
            backup circuit provider: {{ siteDetails.backupCircuitProvider }}
          </div>
          <div>backup circuit status: {{}}</div>
        </div>
      </q-card-section>

      <q-card-actions align="right" class="bg-white text-teal">
        <q-btn flat label="OK" v-close-popup />
      </q-card-actions>
    </q-card>
  </q-dialog> -->
</template>

<script setup lang="ts">
import { countTypes } from "src/api/types";
import { toRefs, ref, reactive, onMounted } from "vue";
import { getStoreDetails, getDetailsList } from "src/api/api";
import { DetailsList, IdetailsListData, IProviderCircuit } from "src/api/types";
import TableStoreDetails from "src/components/tables/TableStoreDetails.vue";
import TableProviderCircuit from "../tables/TableProviderCircuit.vue";
import { useQuasar, QSpinnerDots } from "quasar";
import { insertWorkconnectLog } from "src/api/api";
import CardLegends from "../legends/CardLegends.vue";

const props = defineProps<{
  title: string;
  value: string;
  percentage: string;
  prop_items: countTypes[];
  tableLayout: "storeDetails" | "circuitDetails";
  date_timestamp?: string;
}>();
const $q = useQuasar();
const openFirstModal = ref(false);

const currentTitle = ref("");
const openSecModal = ref(false);
const rowDetails = ref<IdetailsListData[] | IProviderCircuit[]>([]);
const openListOfStore = () => {
  console.log("clicked");
};

const siteDetails = reactive({
  siteId: "",
  loopback1: 0,
  loopback2: 0,
  loopback0: 0,
  primaryCircuitProvider: "",
  backupCircuitProvider: "",
});

const handleOpenList = async (
  store: DetailsList | undefined,
  title: string
) => {
  if (!store) {
    console.warn("Store is undefined/No Table");
    return;
  }

  // console.log(store);

  $q.loading.show({
    message: "Gathering data. Hang on...",
    spinner: QSpinnerDots,
  });
  try {
    insertWorkconnectLog(`Opening lisitng for ${store}`);
    rowDetails.value = await getDetailsList(store);
    currentTitle.value = title;
    openFirstModal.value = true;
  } catch (error) {
    $q.loading.hide();
    $q.notify({
      message: "Could not retrieve Store Lists, Something went wrong!",
      color: "negative",
    });
  }
  $q.loading.hide();
};
</script>
<style scoped>
.q-item-class {
  display: flex;
  flex-direction: column;
}
.q-item__section {
  width: 100%;
}

.big-card {
  border-radius: 5px;
  /* max-width: 250px; */
  /* width: 100%; */
  font-size: 1rem;
}

.small-card {
  /* border-radius: 5px; */
  /* text-align: center; */
  font-size: 0.75rem;
}

.container {
  display: flex;
  width: 100%;
  /* gap: 1em; */
  /* flex-wrap: wrap; */
}

.q-card {
  box-shadow: rgba(0, 0, 0, 0.16) 0px 3px 6px, rgba(0, 0, 0, 0.23) 0px 3px 6px;
}
.child-container {
  /* border-radius: 5px; */
}
.child-container-list {
  /* border-radius: 5px; */
  /* box-shadow: rgba(0, 0, 0, 0.16) 0px 3px 6px, rgba(0, 0, 0, 0.23) 0px 3px 6px; */
}
.child-container-list:hover {
  cursor: pointer;
  transform: scale(1.05);
  z-index: 10;
}
.child-container-list:active {
  box-shadow: rgba(0, 0, 0, 0.16) 0 3px 7px inset;
  transform: translateY(2px);
}
.q-dialog .q-card {
  width: 100%;
  max-width: 1200px;
}

.q-card-section-align {
  display: flex;
  align-items: center;
}

.card-container{
  align-items: center;
}
</style>
