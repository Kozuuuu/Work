<template>
  <div>
    <div v-if="histories.length > 0">
      <div class="justify-space-between mb-5">
        <q-page-container>
          <div class="row">
            <div class="col" cols="12" sm="6" md="3">
              <p class="text-grey-5 text-weight-bold">Virtual IP :</p>
              <span v-if="histories_vip.vip_ip">
                <p class="text-blue-5 text-weight-bold">
                  {{ ' ' + histories_vip.vip_ip }}
                </p>
                <p
                  class="text-green-5 text-weight-bold"
                  v-if="histories_vip.vip_ip == 0"
                >
                  <br />
                  UP
                </p>
                <p class="text-red-5 text-weight-bold" v-else>
                  <br />
                  Down Since:
                  {{ formatDate(histories_vip.vip_lastchange) }}
                </p>
              </span>
              <p class="text-blue-5 text-weight-bold" v-else>No Connection</p>
              <q-card outlined v-if="histories_vip.vip_ip">
                <q-list dense bordered padding>
                  <q-item
                    v-for="(item, i) in histories_vip.vip_events"
                    :key="i"
                    two-line
                  >
                    <q-item-section class="ma-0 pa-0">
                      <q-item-label class="justify-between" flat
                        ><q-item-label class="ma-0 pa-0"
                          >{{ formatDate(item.start) }}
                          <q-item-label class="text-grey-5" align="right">{{
                            getInterval(item.start, item.end)
                          }}</q-item-label>
                        </q-item-label></q-item-label
                      >
                      <q-item-label
                        ><q-item-label class="ma-0 pa-0">{{
                          formatDate(item.end)
                        }}</q-item-label></q-item-label
                      ><q-separator class="mt-2"
                    /></q-item-section>
                  </q-item>
                </q-list>
              </q-card>
            </div>
            <div class="col" cols="12" sm="6" md="3">
              <p class="text-grey-5 text-weight-bold">Primary:</p>
              <span v-if="histories_primary.primary_ip">
                <p class="text-blue-5 text-weight-bold">
                  {{ ' ' + histories_primary.primary_ip }}
                </p>
                <p
                  class="text-green-5 text-weight-bold"
                  v-if="histories_primary.primary == 0"
                >
                  <br />
                  UP
                </p>
                <p class="text-red-5 text-weight-bold" v-else>
                  <br />
                  Down Since:
                  {{ formatDate(histories_primary.primary_lastchange) }}
                </p>
              </span>
              <p class="text-blue-5 text-weight-bold" v-else>No Connection</p>
              <q-card outlined v-if="histories_primary.primary_ip">
                <q-item
                  v-for="(item, i) in histories_primary.primary_events"
                  :key="i"
                  two-line
                >
                  <q-item-section class="ma-0 pa-0">
                    <q-item-label class="justify-between" flat>
                      <q-item-label class="ma-0 pa-0"
                        >{{ formatDate(item.start) }}
                      </q-item-label>
                      <q-item-label class="ma-0 pa-0 grey--text"></q-item-label>
                      <q-item-label class="text-grey-5" align="right">{{
                        getInterval(item.start, item.end)
                      }}</q-item-label>
                    </q-item-label>
                    <q-item-label
                      ><q-item-label class="ma-0 pa-0">{{
                        formatDate(item.end)
                      }}</q-item-label>
                    </q-item-label>
                    <q-separator class="mt-2"
                  /></q-item-section>
                </q-item>
              </q-card>
            </div>

            <div class="col" cols="12" sm="6" md="3">
              <p class="text-grey-5 text-weight-bold">Backup:</p>
              <span v-if="histories_backup.backup_ip">
                <p class="text-blue-5 text-weight-bold">
                  {{ ' ' + histories_backup.backup_ip }}
                </p>
                <p
                  class="text-green-5 text-weight-bold"
                  v-if="histories_backup.backup == 0"
                >
                  <br />
                  UP
                </p>
                <p class="text-red-5 text-weight-bold" v-else>
                  <br />
                  Down Since:
                  {{ formatDate(histories_backup.backup_lastchange) }}
                </p>
              </span>
              <p class="text-grey-5 text-weight-bold" v-else>No Connection</p>
              <q-card outlined v-if="histories_backup.backup_ip">
                <q-item
                  v-for="(item, i) in histories_backup.backup_events"
                  :key="i"
                  two-line
                >
                  <q-item-section class="ma-0 pa-0">
                    <q-item-label class="justify-between" flat
                      ><q-item-label class="ma-0 pa-0">{{
                        formatDate(item.start)
                      }}</q-item-label
                      ><q-item-label class="text-grey-5" align="right">{{
                        getInterval(item.start, item.end)
                      }}</q-item-label></q-item-label
                    >
                    <q-item-label
                      ><q-item-label class="ma-0 pa-0">{{
                        formatDate(item.end)
                      }}</q-item-label></q-item-label
                    ><q-separator class="mt-2"
                  /></q-item-section>
                </q-item>
              </q-card>
            </div>
            <div class="col" cols="12" sm="6" md="3">
              <p class="text-grey-5 text-weight-bold">Third Circuit:</p>
              <span v-if="histories_thrdcircuit.thrdcircuit_ip">
                <p class="text-blue-5 text-weight-bold">
                  {{ ' ' + histories_thrdcircuit.thrdcircuit_ip }}
                </p>
                <p
                  class="text-green-5 text-weight-bold"
                  v-if="histories_thrdcircuit.thrdcircuit == 0"
                >
                  <br />
                  UP
                </p>
                <p class="text-red-5 text-weight-bold" v-else>
                  <br />
                  Down Since:
                  {{ formatDate(histories_thrdcircuit.thrdcircuit_lastchange) }}
                </p>
              </span>
              <p class="text-blue-5 text-weight-bold" v-else>No Connection</p>
              <q-card outlined v-if="histories_thrdcircuit.thrdcircuit_ip">
                <q-item
                  v-for="(item, i) in histories_thrdcircuit.thrdcircuit_events"
                  :key="i"
                  two-line
                >
                  <q-item-section class="ma-0 pa-0">
                    <q-item-label class="d-flex justify-space-between" flat
                      ><q-item-label class="ma-0 pa-0">{{
                        formatDate(item.start)
                      }}</q-item-label
                      ><q-item-label class="ma-0 pa-0 grey--text"></q-item-label
                      ><q-item-label class="text-grey-5" align="right">{{
                        getInterval(item.start, item.end)
                      }}</q-item-label></q-item-label
                    >
                    <q-item-label
                      ><q-item-label class="ma-0 pa-0">{{
                        formatDate(item.end)
                      }}</q-item-label></q-item-label
                    ><q-separator class="mt-2"
                  /></q-item-section>
                </q-item>
              </q-card>
            </div></div
        ></q-page-container>
      </div>
    </div>
  </div>
</template>
<script lang="ts">
import moment from 'moment';
import { ref } from 'vue';

export default {
  props: {
    histories: Array,
    histories_vip: Object,
    histories_primary: Object,
    histories_backup: Object,
    histories_thrdcircuit: Object,
    gettingHistories: Boolean,
  },
  setup(props) {
    console.log('props: ', props);
    const histories_vip = props.histories_vip;
    console.log('histories_vip: ', histories_vip);
    // const histories_primary = props.histories_primary.find((x) => x);
    // console.log("histories_primary: ", histories_primary.vip_lastchange);

    const search = ref('');
    const headers = [
      {
        text: 'Circuit',
        align: 'start',
        value: 'circuit',
      },
      { text: 'Type', value: 'type' },
      { text: 'Provider', value: 'provider' },
      { text: 'Account', value: 'account' },
    ];

    const assets = ref([]);

    function formatDate(date) {
      return moment(date, 'YYYY-MM-DD HH:mm:ss.SS zzz').format(
        'MMM DD YYYY | h:mm:ss a'
      );
    }

    const getInterval = (start, end) => {
      var _start = moment(start);
      var _end = moment(end);
      return _end.from(_start, true);
    };

    return {
      search,
      headers,
      assets,
      histories_vip,
      // histories_primary,
      formatDate,
      getInterval,
    };
  },
};
</script>
