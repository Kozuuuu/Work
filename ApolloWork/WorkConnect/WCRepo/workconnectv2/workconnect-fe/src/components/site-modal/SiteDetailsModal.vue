<template>
  <!-- <q-btn dense round flat icon="description" @click="alert" color="info">
    <q-tooltip anchor="center left" self="center right" :offset="[5, 50]">
      Show Details
    </q-tooltip></q-btn
  > -->

  <q-dialog
    v-model="alert"
    transition-show="slide-up"
    transition-hide="slide-down"
    persistent
    @keydown.esc="handleClose"
    position="top"
  >
    <q-card>
      <SiteInfoTabs :handle-close="handleClose" />
      <q-card-actions align="right">
        <q-btn flat label="Close" dense @click="handleClose" />
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue';
import SiteInfoTabs from './SiteInfoTabs.vue';
const props = defineProps<{ rowsDetails: Object; showModal: boolean }>();
const emit = defineEmits(['close']);
const alert = ref(props.showModal);
const tabs = ref('');
const handleClose = () => {
  alert.value = false;
  emit('close');
};

watch(
  () => props.showModal,
  (newValue) => {
    alert.value = newValue;
  }
);
</script>

<style scoped>
.q-card {
  max-width: 1200px;
  width: 100%;
}
.q-card__section--vert {
  padding: 0;
}
.q-btn:hover {
  background-color: #ab2e3c;
  color: white;
  scale: 1.02;
}
</style>
