<template>
  <div v-for="item in routes" :key="item.name">
    <q-expansion-item
      v-if="
        item.children != null &&
        item.name != 'Stores' &&
        // @ts-ignore
        ((item.meta.roles.some((x) => $keycloak.hasRealmRole(x)) &&
          item.hidden != true) ||
          item.meta.roles.includes('any'))
      "
      :label="item.name"
      :icon="item.meta.icon"
      expand-icon-class="text-white"
    >
      <!-- <q-list class="q-pl-lg">
        <layout-drawer-list :routes="item.children" />
      </q-list> -->
      <!-- <q-expansion-item
      v-if="
        item.children != null &&
        ((item.meta.roles.some((x) => $keycloak.hasRealmRole(x)) &&
          item.hidden != true) ||
          item.meta.roles.includes('any'))
      "
      :label="item.name"
      :icon="item.meta.icon"
      expand-icon-class="text-white"
    >
      <q-list class="q-pl-lg">
        <layout-drawer-list :routes="item.children" />
      </q-list>
    </q-expansion-item> -->
      <q-list>
        <q-item
          :to="item.path"
          active-class="drawerActive"
          @click="insertWorkconnectLog(`Navigating to route ${item.name}`)"
        >
          <q-item-section avatar>
            <q-icon :name="item.meta.icon" />
          </q-item-section>
          <q-item-section>
            <q-item-label>{{ item.name }}</q-item-label>
          </q-item-section>
        </q-item>
      </q-list>
    </q-expansion-item>
    <q-list v-else>
      <q-item
        v-if="
          // @ts-ignore
          (item.meta.roles.some((x) => $keycloak.hasRealmRole(x)) &&
            item.hidden != true) ||
          item.meta.roles.includes('any')
        "
        :to="item.path"
        active-class="q-item-no-link-highlighting drawerActive"
      >
        <!-- @click="insertWorkconnectLog(`Navigating to route ${item.name}`)" -->
        <q-item-section avatar>
          <q-icon :name="item.meta.icon" />
        </q-item-section>
        <q-item-section>
          <q-item-label>{{ item.name }}</q-item-label>
        </q-item-section>
      </q-item>
    </q-list>
  </div>
</template>

<script setup lang="ts">
import LayoutDrawerList from "src/layouts/LayoutDrawerList.vue";
import { defineComponent, ref } from "vue";
import { insertWorkconnectLog } from "src/api/api";
// export default defineComponent({
//   name: "LayoutDrawerList",
//   props: {
//     routes: {
//       type: Object,
//       required: true,
//     },
//   },
// });
// path: "/Reports",
//         component: () => import("pages/Reports.vue"),
//         name: "Circuit Reports",
//         meta: { icon: "summarize", roles: ["any"] },
const props = defineProps<{
  routes?: any;
}>();
</script>

<style scoped>
.drawerActive {
  background-color: #3498db4d;
  color: #01579b;
  font-weight: bold;
  border-radius: 15px;
  margin: 5px;
}
</style>
