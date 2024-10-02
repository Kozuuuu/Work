<template>
  <q-card-section>
    <q-tabs
      v-model="tabs"
      dense
      class="bg-primary text-white"
      active-color="dark"
      indicator-color="dark"
      align="justify"
    >
      <q-tab name="siteInfo" label="Site Info" />
      <q-tab name="devices" label="Devices" />

      <q-tab name="circuitsAndInterfaces" label="Circuits and Interfaces" />

      <q-tab name="networkHistory" label="Network History" />
      <q-btn
        icon="close"
        class="btn-close"
        flat
        @click="handleClose"
        square
      ></q-btn>
    </q-tabs>
    <q-separator />

    <q-tab-panels v-model="tabs" animated>
      <q-tab-panel name="siteInfo">
        <div class="site__infos">
          <div v-for="(value, key) in filteredDetailsOfSite" :key="key">
            <!-- v-if="value !== '' || value !== undefined" -->
            <div v-if="!shouldExemptKey(key)">
              <p>
                {{ formatString(key) }}:
                <span class="text-bold"
                  ><br />
                  {{ value }}</span
                >
              </p>
            </div>
          </div>
        </div>
      </q-tab-panel>

      <q-tab-panel name="devices" class="q-tab-panel-network-history">
        <q-tabs
          v-model="deviceTab"
          dense
          class="text-dark"
          active-color="primary"
          indicator-color="primary"
          align="justify"
          narrow-indicator
        >
          <q-tab name="devicesNetbox" label="Netbox" />
          <q-tab name="devicesAtis" label="Atis" />
        </q-tabs>
        <q-separator />
        <q-tab-panels v-model="deviceTab">
          <q-tab-panel name="devicesNetbox">
            Lorem ipsum dolor sit, amet consectetur adipisicing elit. Ipsum
            magni fuga explicabo vitae quas autem est aut! Dolor, distinctio
            ducimus.
          </q-tab-panel>
          <q-tab-panel name="devicesAtis">
            Lorem ipsum dolor sit amet consectetur, adipisicing elit. Sapiente
            delectus illum asperiores mollitia! Tenetur, adipisci accusamus
            doloremque saepe omnis a id aliquid dolorem, sint culpa excepturi
            nihil, iste amet maxime!
          </q-tab-panel>
        </q-tab-panels>
      </q-tab-panel>

      <q-tab-panel
        name="circuitsAndInterfaces"
        class="q-tab-panel-network-history"
      >
        <q-tabs
          v-model="circuitsAndInterfacesTab"
          dense
          class="text-dark"
          active-color="primary"
          indicator-color="primary"
          align="justify"
          narrow-indicator
        >
          <q-tab name="C&I_Netbox" label="Netbox" />
          <q-tab name="C&I_Atis" label="Atis" />
        </q-tabs>
        <q-separator />
        <q-tab-panels v-model="circuitsAndInterfacesTab">
          <q-tab-panel name="C&I_Netbox">
            Lorem ipsum dolor sit, amet consectetur adipisicing elit. Ipsum
            magni fuga explicabo vitae quas autem est aut! Dolor, distinctio
            ducimus.
          </q-tab-panel>
          <q-tab-panel name="C&I_Atis">
            Lorem ipsum dolor sit amet consectetur, adipisicing elit. Sapiente
            delectus illum asperiores mollitia! Tenetur, adipisci accusamus
            doloremque saepe omnis a id aliquid dolorem, sint culpa excepturi
            nihil, iste amet maxime!
          </q-tab-panel>
        </q-tab-panels>
      </q-tab-panel>

      <q-tab-panel
        v-model="tab"
        name="networkHistory"
        class="q-tab-panel-network-history"
      >
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
          <q-tab name="SNMP" label="SNMP" />
          <q-tab name="zabbix" label="Zabbix" />
        </q-tabs>
        <q-separator />
        <q-tab-panels v-model="tab">
          <q-tab-panel name="prometheus">
            <new-prometheus :site-id="detailsOfSite.site_id" />
          </q-tab-panel>
          <q-tab-panel name="SNMP">
            <SNMP :site-id="detailsOfSite.site_id" />
          </q-tab-panel>
          <q-tab-panel name="zabbix">
            Zabbix Lorem ipsum dolor sit amet consectetur adipisicing elit.
            <Zabbix :site-id="detailsOfSite.site_id" />
          </q-tab-panel>
        </q-tab-panels>
        <q-separator />
      </q-tab-panel>
    </q-tab-panels>
  </q-card-section>
</template>

<script setup lang="ts">
import { ref, computed, toRefs } from "vue";
import { useSiteStore } from "src/stores/sites/stores";
// import Prometheus from './Prometheus.vue';
import SNMP from "src/components/site-modal/network-history/SNMP.vue";
import NewPrometheus from "./NewPrometheus.vue";
import Zabbix from "src/components/site-modal/network-history/Zabbix.vue";
const props = defineProps<{ handleClose: () => void }>();
// const handleClose = toRefs(props);
const store = useSiteStore();
const detailsOfSite = store.$state.detailsSite;
const tabs = ref("siteInfo");
const tab = ref("prometheus");
const deviceTab = ref("devicesNetbox");
const circuitsAndInterfacesTab = ref("C&I_Netbox");

const filteredDetailsOfSite = computed(() => {
  return Object.entries(detailsOfSite)
    .filter(([key, value]) => !shouldExemptKey(key))
    .reduce((obj, [key, value]) => ({ ...obj, [key]: value }), {});
});

function formatString(inputString: string) {
  return inputString
    .split("_") // Split the string into an array using underscores as separators
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
    .join(" "); // Join the array back into a string with spaces
}

function shouldExemptKey(key: string) {
  return (
    key === "primary_ip" ||
    key === "loop_back_0_ip" ||
    key === "backup_ip" ||
    key === "loop_back_0_status"
  );
}

// function closeModal() {
//   props.handleClose();
// }
</script>

<style lang="scss" scoped>
.site__infos {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  grid-gap: 0.5em;
  text-align: center;
}
.q-tab-panel-network-history {
  padding: 0;
}
.btn-close:hover {
  cursor: pointer;
  background-color: red;
}
</style>
