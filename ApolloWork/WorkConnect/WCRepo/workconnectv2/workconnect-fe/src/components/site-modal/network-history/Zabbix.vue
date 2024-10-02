<template>
  <div>
    <History
      :histories="histories"
      :histories_vip="histories_vip"
      :histories_primary="histories_primary"
      :histories_backup="histories_backup"
      :histories_thrdcircuit="histories_thrdcircuit"
      :gettingHistories="gettingHistories"
      :historyError="historyError"
    />
    <div class="row" justify="space-around">
      <div
        v-if="histories.length === 0 && !gettingHistories && !historyError"
        class="text-grey-5"
        align="center"
      >
        No data available
      </div>
    </div>

    <q-skeleton
      class="mx-auto my-5"
      type="QAvatar"
      v-if="gettingHistories"
    ></q-skeleton>
  </div>
</template>

<script lang="ts">
import History from 'src/components/downTimeHistory/index.vue';
import { defineComponent, ref, onMounted } from 'vue';
import { useQuasar } from 'quasar';
import { getHistoryZabbix } from 'src/api/testApi';
export default defineComponent({
  components: { History },
  props: ['siteId'],
  setup(props) {
    const $q = useQuasar();

    const histories = ref([0, 1, 2]);
    const histories_vip = ref({});
    const histories_primary = ref({});
    const histories_backup = ref({});
    const histories_thrdcircuit = ref({});
    const gettingHistories = ref(false);
    const historyError = ref(false);
    const serverTimeout = ref(false);

    async function getHistory() {
      histories.value = [];
      histories_vip.value = {};
      histories_primary.value = {};
      histories_backup.value = {};
      histories_thrdcircuit.value = {};
      gettingHistories.value = true;
      try {
        historyError.value = false;
        histories.value = await getHistoryZabbix(props.siteId);
        for (var i in histories.value) {
          if (histories.value[i].vip_ip)
            histories_vip.value = histories.value[i];
          else if (histories.value[i].primary_ip)
            histories_primary.value = histories.value[i];
          else if (histories.value[i].backup_ip)
            histories_backup.value = histories.value[i];
          else if (histories.value[i].thrdcircuit_ip)
            histories_thrdcircuit.value = histories.value[i];
        }
        gettingHistories.value = false;
      } catch (e) {
        $q.notify({
          type: 'negative',
          message: 'Error Getting Downtime History',
        });
        serverTimeout.value = true;
        gettingHistories.value = false;
        historyError.value = true;
      }
    }

    onMounted(() => {
      getHistory();
    });
    return {
      histories,
      histories_vip,
      histories_primary,
      histories_backup,
      histories_thrdcircuit,
      gettingHistories,
      historyError,
      serverTimeout,
      getHistory,
    };
  },
});
</script>

<style scoped></style>
