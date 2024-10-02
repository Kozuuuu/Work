<template>
  <q-layout view="hHh Lpr lff" class="container-width">
    <q-header elevated class="container-width">
      <q-toolbar class="bg-white text-white">
        <q-btn
          flat
          dense
          round
          @click="toggleLeftDrawer"
          icon="menu"
          class="menu-color"
          aria-label="Menu"
        />
        <q-toolbar-title>
          <q-img
            src="../assets/WorkConnect.png"
            alt="Work Connect Dashboard"
            width="130px"
          />
        </q-toolbar-title>

        <div class="q-gutter-sm row items-center no-wrap">
          <q-toolbar-title class="gt-xs">
            <span class="text-black"> {{ getName }}</span>
          </q-toolbar-title>
          <profile />
        </div>
      </q-toolbar>
    </q-header>

    <q-drawer
      v-model="leftDrawerOpen"
      show-if-above
      :mini="miniState"
      @mouseover="miniState = false"
      @mouseout="miniState = true"
      class="bg-white text-grey container-width"
    >
      <!-- <q-item-label header class="text-white"></q-item-label> -->
      <layout-drawer-list :routes="showRoutes" />
    </q-drawer>

    <q-page-container class="main-bg">
      <router-view />
    </q-page-container>
    <!-- 
    <q-footer elevated class="bg-dark text-white">
      <q-toolbar> </q-toolbar>
    </q-footer> -->
  </q-layout>
</template>

<script setup lang="ts">
import { ref } from "vue";
import { auth } from "stores/auth";

import { storeToRefs } from "pinia";
import routes from "../router/routes.js";
import LayoutDrawerList from "./LayoutDrawerList.vue";
import Profile from "../widget/AppProfile.vue";

const leftDrawerOpen = ref(false);
const store = auth();

const { getName } = storeToRefs(store);

const showRoutes = ref(routes[0].children);

const toggleLeftDrawer = () => {
  leftDrawerOpen.value = !leftDrawerOpen.value;
};

const miniState = ref(true);
</script>
<style scoped>
.menu-color {
  color: #0054d3;
}
.main-bg {
  background: linear-gradient(to bottom, #3498db70, #ffffff);
}
</style>
