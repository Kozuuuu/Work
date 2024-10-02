<template>
  <div>
    <q-table
      :rows="data"
      :columns="columns"
      row-key="id"
      :pagination="{ rowsPerPage: -1 }"
      :hide-bottom="true"
      dense
      separator="cell"
      style="max-width: 1920px; margin: 0 auto"
      :loading="data.length === 0"
    >
      <template v-slot:body="props">
        <q-tr :props="props" @click="handleClick(props.row.provider)">
          <q-td key="provider " :props="props">
            <span>
              {{ props.row.provider }}
            </span>
          </q-td>
          <q-td key="atis" :props="props">
            <span>
              {{ props.row.atis }}
            </span>
          </q-td>
          <q-td key="active" :props="props">
            <span>
              {{ props.row.active }}
            </span>
          </q-td>
        </q-tr>
      </template>

      <template v-slot:bottom-row>
        <q-tr v-if="data.length > 0" class="table-bottom">
          <q-td :class="'centered'" style="font-weight: bold; font-size: medium"
            >TOTAL:</q-td
          >
          <q-td
            :class="'centered'"
            style="font-weight: bold; font-size: medium"
            >{{ totalAtis }}</q-td
          >
          <q-td
            :class="'centered'"
            style="font-weight: bold; font-size: medium"
            >{{ totalActive }}</q-td
          >
        </q-tr>
      </template>
    </q-table>

    <!-- Dialog for displaying filtered inventory -->
    <q-dialog v-model="showInventoryModal">
      <q-card style="max-width: 900px; width: 100%">
        <q-card-section class="current-provider">
          <div class="provider-info">
            Currently browsing: <strong>{{ selectedProvider }}</strong>
            <div class="close-button">
              <q-btn v-close-popup icon="close" flat />
            </div>
          </div>
          <div class="sticky-buttons">
            <q-tabs v-model="selectedTab" class="custom-tabs">
              <q-tab name="autodiscoverAndAtis">
                Autodiscover & ATIS ({{ autodiscoverAndAtisCount }})
              </q-tab>
              <q-tab name="autodiscoverOnly">
                Autodiscover Only ({{ autodiscoverOnlyCount }})
              </q-tab>
              <q-tab name="atisOnly"> ATIS Only ({{ atisOnlyCount }}) </q-tab>
            </q-tabs>
            <q-input
              v-model="filter"
              filled
              dense
              label="Search"
              debounce="300"
              color="primary"
              clearable
              style="margin: 2%; margin-bottom: -5px"
            >
              <template #append>
                <q-icon name="search" />
              </template>
            </q-input>
          </div>
        </q-card-section>
        <q-card-section> </q-card-section>

        <q-card-section>
          <!-- Table to display data -->
          <div class="table-container">
            <div class="filtered-table">
              <q-table
                :rows="filteredInventory(selectedTab)"
                :columns="selectedInventoryColumns"
                :pagination="{ rowsPerPage: -1 }"
                :filter="filter"
              >
                <template v-slot:body="props">
                  <q-tr :props="props" @click="handleClick(props.row.provider)">
                    <q-td key="site_id" :props="props">
                      <span>{{ props.row.site_id }}</span>
                    </q-td>
                    <q-td key="name" :props="props" >
                      <span>{{ props.row.name }}</span>
                    </q-td>
                    <q-td
                      key="acc_no"
                      :props="props"
                      v-if="selectedTab !== 'autodiscoverOnly'"
                    >
                      <span>{{ props.row.acc_no }}</span>
                    </q-td>
                    <q-td
                      key="last_update"
                      :props="props"
                    >
                      <span>{{ props.row.last_update }}</span>
                    </q-td>
                    <q-td
                      key="status"
                      :props="props"
                      v-if="selectedTab !== 'autodiscoverOnly'"
                    >
                      <span>{{ props.row.status }}</span>
                    </q-td>


                    <!-- <q-td key="autodiscover" :props="props">
                    <span>{{ props.row.autodiscover }}</span>
                  </q-td>
                  <q-td key="atis" :props="props">
                    <span>{{ props.row.atis }}</span>
                  </q-td> -->
                  </q-tr>
                </template>
              </q-table>
            </div>
          </div>
        </q-card-section>
      </q-card>
    </q-dialog>
    <!-- <q-dialog v-model="showInventoryModal">
      <q-card>
        <q-card-section>
          <q-table :rows="selectedProviderInventory" :columns="inventoryColumns" :pagination="{ rowsPerPage: -1 }" row-key="id">
            <template v-slot:body="props">
              <q-tr :props="props" @click="handleClick(props.row.provider)">
                <q-td key="site_id" :props="props">
                  <span>
                    {{ props.row.site_id }}
                  </span>
                </q-td>
                <q-td key="provider" :props="props">
                  <span>
                    {{ props.row.provider }}
                  </span>
                </q-td>
                <q-td key="atis" :props="props">
                  <span>
                    {{ props.row.atis }}
                  </span>
                </q-td>
                <q-td key="autodiscover" :props="props">
                  <span>
                    {{ props.row.autodiscover }}
                  </span>
                </q-td>
              </q-tr>

            </template>
          </q-table>
        </q-card-section>
      </q-card>
    </q-dialog> -->
  </div>
</template>

<script setup lang="ts">
import { defineProps, ref, computed, onMounted, watchEffect } from "vue";
import { QTableColumn } from "quasar";
import { IcircuitReport, rowsProviderInventory } from "src/api/types";
import { getAtisInventory } from "src/api/api";
import { useRouter, useRoute } from "vue-router";

const route = useRoute();
const router = useRouter();

const filter = ref("");
const providerStoreList = ref(false);
const showInventoryModal = ref(false); // Reactive variable to control the visibility of the inventory modal
const selectedProviderInventory = ref<rowsProviderInventory[]>([]); // Reactive variable to store the selected provider's inventory data

// Define filters for the button toggle
const filters = [
  { value: "autodiscoverAndAtis", label: "Autodiscover & ATIS" },
  { value: "autodiscoverOnly", label: "Autodiscover Only" },
  { value: "atisOnly", label: "ATIS Only" },
];

// Define props
const props = defineProps<{
  data: IcircuitReport[];
}>();

const totalAtis = ref(0);
const totalActive = ref(0);
watchEffect(() => {
  totalAtis.value = props.data.reduce(
    (total, item) => total + (item.atis || 0),
    0
  );
  totalActive.value = props.data.reduce(
    (total, item) => total + (item.active || 0),
    0
  );
});

// // Create a reactive variable to track data loading state
// const isDataLoaded = ref(false);

// // Watch for changes to the data prop
// watch(
//   () => props.data,
//   (newValue) => {
//     if (newValue && newValue.length > 0) {
//       isDataLoaded.value = true; // Set data loaded state to true when data is received
//     }
//   }
// );
// Reactive variable for selected tab
const selectedTab = ref<string>("autodiscoverAndAtis");
const selectedProvider = ref<String>("");
const selectedFilter = filters.find((f) => f.value === selectedTab.value) || {
  label: "",
};
const inventoryColumnFull: QTableColumn[] = [
  {
    name: "site_id",
    required: true,
    label: "Site ID",
    align: "center",
    field: "site_id",
    sortable: true,
  },
  {
    name: "name",
    required: true,
    label: "Name",
    align: "center",
    field: "name",
    sortable: true,
  },
  {
    name: "acc_no",
    required: true,
    label: "Account Number",
    align: "center",
    field: "acc_no",
    sortable: true,
  },
  {
    name: "last_update",
    required: true,
    label: "Last Update",
    align: "center",
    field: "last_update",
    sortable: true,
  },
  {
    name: "status",
    required: true,
    label: "Status on ATIS",
    align: "center",
    field: "status",
    sortable: true,
  }

];

const inventoryColumnAtisOnly: QTableColumn[] = [
  {
    name: "site_id",
    required: true,
    label: "Site ID",
    align: "center",
    field: "site_id",
    sortable: true,
  },
  {
    name: "name",
    required: true,
    label: "Name",
    align: "center",
    field: "name",
    sortable: true,
  },
  {
    name: "acc_no",
    required: true,
    label: "Account Number",
    align: "center",
    field: "acc_no",
    sortable: true,
  },
  {
    name: "status",
    required: true,
    label: "Status on ATIS",
    align: "center",
    field: "status",
    sortable: true,
  },
];

const inventoryColumnAutoDiscoverOnly: QTableColumn[] = [
  {
    name: "site_id",
    required: true,
    label: "Site ID",
    align: "center",
    field: "site_id",
    sortable: true,
  },
  {
    name: "name",
    required: true,
    label: "Name",
    align: "center",
    field: "name",
    sortable: true,
  },
  {
    name: "last_update",
    required: true,
    label: "Last Update",
    align: "center",
    field: "last_update",
    sortable: true,
  },
];

const columns: QTableColumn[] = [
  {
    name: "provider",
    required: true,
    label: "Provider",
    align: "center",
    field: "provider",
    sortable: true,
  },
  {
    name: "atis",
    required: true,
    label: "ATIS",
    align: "center",
    field: "atis",
    sortable: true,
  },
  {
    name: "active",
    required: true,
    label: "Active",
    align: "center",
    field: "active",
    sortable: true,
  },
  // {
  //   name: "notInList",
  //   required: true,
  //   label: "Active But Not In ATIS",
  //   align: "center",
  //   field: "notInList",
  //   sortable: true,
  // },
  // {
  //   name: "notFoundWMac",
  //   required: true,
  //   label: "Not Found With Mac",
  //   align: "center",
  //   field: "notFoundWMac",
  //   sortable: true,
  // },
  // {
  //   name: "notFoundWoutMac",
  //   required: true,
  //   label: "Not Found Without Mac",
  //   align: "center",
  //   field: "notFoundWoutMac",
  //   sortable: true,
  // },
];

// Function to filter inventory data based on the selected filter
const filteredInventory = (filter: string) => {
  switch (filter) {
    case "autodiscoverAndAtis":
      return selectedProviderInventory.value.filter(
        (item) => item.autodiscover && item.atis
      );
    case "autodiscoverOnly":
      return selectedProviderInventory.value.filter(
        (item) => item.autodiscover && !item.atis
      );
    case "atisOnly":
      return selectedProviderInventory.value.filter(
        (item) => !item.autodiscover && item.atis
      );
    default:
      return [];
  }
};

const autodiscoverAndAtisCount = computed(
  () => filteredInventory("autodiscoverAndAtis").length
);
const autodiscoverOnlyCount = computed(
  () => filteredInventory("autodiscoverOnly").length
);
const atisOnlyCount = computed(() => filteredInventory("atisOnly").length);

const selectedInventoryColumns = computed(() => {
  // Check if the selected tab is autodiscoverOnly
  if (selectedTab.value === "autodiscoverOnly") {
    return inventoryColumnAutoDiscoverOnly;
  }
  if (selectedTab.value === "atisOnly"){
    return inventoryColumnAtisOnly;
  }else {
    return inventoryColumnFull;
  }
});

const handleClick = async (provider: string) => {
  try {
    // Fetch inventory data for the selected provider
    const inventoryData = await getAtisInventory(provider);
    selectedProvider.value = provider;
    // Store the fetched inventory data
    selectedProviderInventory.value = inventoryData;
    // Show the inventory modal
    showInventoryModal.value = true;
  } catch (error) {
    console.error("Error fetching inventory data:", error);
  }
};
// Function to download the full report
const downloadFullReport = () => {
  const currentDate = new Date().toISOString().split("T")[0]; // Get current date in YYYY-MM-DD format
  const folderName = `${currentDate} 08:55`; // Construct folder name
  const folderURL = `/reports/${encodeURIComponent(folderName)}`; // Construct folder URL
  window.location.href = folderURL; // Trigger download by navigating to the folder URL
};

const modalWidth = ref("120%");

onMounted(() => {
  const tabsContainer = document.querySelector(".custom-tabs") as HTMLElement;
  if (tabsContainer) {
    const tabsWidth = tabsContainer.offsetWidth;
    modalWidth.value = `${tabsWidth}px`;
  }
});
</script>

<style scoped>
.q-table {
  font-size: 12px;
  /* Increase font size */
  width: 100%;
  /* Make the table width 100% of its container */
  max-width: none;
  /* Remove maximum width constraint */
}

.centered {
  text-align: center;
}

.sticky-buttons {
  margin-top: -10px;
}

.provider-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.close-button {
  margin-left: auto;
  /* Push the button to the right */
}

.current-provider {
  position: sticky;
  top: 0;
  background-color: #fff;
  /* Adjust as needed */
  padding: 15px;
  z-index: 2;
  /* Ensure it appears above the table */
}

.filtered-table {
  width: 100%;
  /* Set the width of the filtered table to 100% */
  margin-top: -20px;
}

.table-container {
  display: flex;
  flex-direction: column;
  /* Change flex direction to column */
  align-items: center;
  /* Center align items */
}

.custom-tabs .q-tab {
  width: auto !important;
  /* Set width to auto for each tab */
}
.table-bottom {
  background-color: #dfdfdf;
  /* border: 1px solid black; */
}
</style>
