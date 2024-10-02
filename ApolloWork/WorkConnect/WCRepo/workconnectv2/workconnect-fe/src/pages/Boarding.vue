<template>
  <q-page padding>
    <q-select
      :options="playbook_options()"
      v-model="boardingType"
      style="max-width: 300px"
      filled
      emit-value
      map-options
      dense
      class="q-py-sm"
    />
    <q-card
      v-if="boardingType === 'provision'"
      class="q-pa-md"
      style="max-width: 400px"
    >
      <q-form class="q-gutter-md" @submit="provision" @reset="onReset">
        <div>Provision GTv3</div>
        <q-input
          filled
          v-model.trim="storeId"
          label="Store ID"
          :mask="'ST-XXXX'"
          lazy-rules
          :rules="[
            (val) => (val && val.length > 0) || 'Please Enter Store Id ST-XXXX',
          ]"
        />

        <q-input
          filled
          v-model.trim="ipAdd"
          type="text"
          label="Ip"
          lazy-rules
          clearable
          :rules="[
              (val: string) =>
                isValidIPAddress(val) || 'Please Enter a valid IP Address',
            ]"
        />
        <q-select
          filled
          label="Router Type"
          v-model="routerType"
          :options="['mikrotik', 'ruijie']"
          clearable
          :rules="[
            (val) => (val && val.length > 0) || 'Please Select Router Type',
          ]"
        >
        </q-select>
        <div>
          <q-btn
            label="Submit"
            type="submit"
            color="primary"
            :disable="!storeId || !routerType || !ipAdd"
          />
          <q-btn
            label="Reset"
            type="reset"
            color="primary"
            flat
            class="q-ml-sm"
          />
        </div>
      </q-form>
    </q-card>

    <q-card
      v-if="boardingType === 'offBoard'"
      class="q-pa-md"
      style="max-width: 400px"
    >
      <q-form class="q-gutter-md" @submit="offBoarding" @reset="onReset">
        <div>Off Boarding</div>
        <q-input
          filled
          v-model="storeId"
          label="Store ID"
          :mask="'ST-XXXX'"
          lazy-rules
          :rules="[
            (val) => (val && val.length > 6) || 'Please Enter Store Id ST-XXXX',
          ]"
        />
        <div>
          <q-btn label="Submit" type="submit" color="primary" />
          <q-btn
            label="Reset"
            type="reset"
            color="primary"
            flat
            class="q-ml-sm"
          />
        </div>
      </q-form>
    </q-card>
    <q-card
      v-if="boardingType === 'update'"
      class="q-pa-md"
      style="max-width: 400px"
    >
      <q-form
        class="q-gutter-md"
        @submit="onUpdateStoreStatus"
        @reset="onReset"
      >
        <div>Update Store Status</div>
        <q-input
          filled
          v-model="storeId"
          label="Store ID"
          lazy-rules
          :rules="[(val) => (val && val.length > 0) || 'Please type something']"
        />
        <q-select
          filled
          label="Store Status"
          v-model="status"
          :options="['active', 'temporarily_closed', 'closed']"
          clearable
          :rules="[
            (val) => (val && val.length > 0) || 'Please select Store Status',
          ]"
        >
        </q-select>
        <div>
          <q-btn label="Submit" type="submit" color="primary" />
          <q-btn
            label="Reset"
            type="reset"
            color="primary"
            flat
            class="q-ml-sm"
          />
        </div>
      </q-form>
    </q-card>
  </q-page>
</template>

<script setup lang="ts">
import { ref, watch } from "vue";
import {
  onBoarding,
  GTv3,
  mngnmtVpn,
  ruijieV3,
  offBoardingStore,
  updateStoreStatus,
} from "src/api/playbook";
import { auth } from "src/stores/auth";
import { storeToRefs } from "pinia";
import { useQuasar } from "quasar";

import request from "axios";
import { insertWorkconnectLog } from "src/api/api";
const $q = useQuasar();
const storeId = ref("ST-");
const ipAdd = ref("");
const routerType = ref<"mikrotik" | "ruijie" | "">("");
const status = ref("");
const boardingType = ref<string>("Select Playbook");

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

const playbook_options = (): { label: string; value: string }[] => {
  let optionz = [];
  if (hasPermission("ROLE_PLAYBOOK_ONBOARDING")) {
    optionz.push({
      label: "Provision",
      value: "provision",
    });
  }
  // if (hasPermission("ROLE_PLAYBOOK_ONBOARDING")) {
  //   optionz.push({
  //     label: "On Board",
  //     value: "onboard",
  //   });
  // }
  if (hasPermission("ROLE_PLAYBOOK_OFFBOARDING")) {
    optionz.push({
      label: "Off Board",
      value: "offBoard",
    });
  }
  if (hasPermission("ROLE_PLAYBOOK_UPDATE_STATUS")) {
    optionz.push({
      label: "Update Store Status",
      value: "update",
    });
  }

  // if (hasPermission("ROLE_PLAYBOOK_WHITELISTED_IPS")) {
  //   optionz.push({
  //     label: "Whitelisted IPs",
  //     value: "whitelisted_ips",
  //   });
  // }
  // if (hasPermission("ROLE_PLAYBOOK_GOLDEN_TEMPLATE")) {
  //   optionz.push({
  //     label: "Golden Template",
  //     value: "golden_template",
  //   });
  // }
  return optionz;
};

const provision = async () => {
  try {
    if (routerType.value === "mikrotik") {
      $q.loading.show({
        message: "Running Management VPN...",
      });

      const responseMngmntVpn = await mngnmtVpn(storeId.value, ipAdd.value);
      $q.notify({
        message: `${responseMngmntVpn.message} ${responseMngmntVpn.status} Job ID: ${responseMngmntVpn.jobId}`,
        color: "accent",
        position: "top",
      });

      $q.loading.show({
        message: "Running Golden Template v3...",
      });
      const responseGTv3 = await GTv3(storeId.value, ipAdd.value);
      $q.notify({
        message: `${responseGTv3.message} ${responseGTv3.status} Job ID: ${responseGTv3.jobId}`,
        color: "accent",
        position: "top",
      });

      $q.loading.show({
        message: "Running Off Boarding...",
      });
      const responseOffBoard = await offBoardingStore(storeId.value);
      $q.notify({
        message: `${responseOffBoard.message} ${responseOffBoard.status} Job ID: ${responseOffBoard.jobId}`,
        color: "accent",
        position: "top",
      });

      $q.loading.show({
        message: "Running On Boarding...",
      });

      const responseonBoard = await onBoarding(
        storeId.value,
        responseGTv3.jobId
      );
      $q.notify({
        message: `${responseonBoard.message} ${responseonBoard.status} Job ID: ${responseonBoard.jobId}`,
        color: "accent",
        position: "top",
      });
    }

    if (routerType.value === "ruijie") {
      $q.loading.show({
        message: "Running Ruijie v3...",
      });
      const responseRuijieV3 = await ruijieV3(storeId.value, ipAdd.value);
      $q.notify({
        message: `${responseRuijieV3.message} ${responseRuijieV3.status} Job ID: ${responseRuijieV3.jobId}`,
        color: "accent",
        position: "top",
      });

      $q.loading.show({
        message: "Running Off Boarding...",
      });

      const responseOffBoard = await offBoardingStore(storeId.value);
      $q.notify({
        message: `${responseOffBoard.message} ${responseOffBoard.status} Job ID: ${responseOffBoard.jobId}`,
        color: "accent",
        position: "top",
      });

      $q.loading.show({
        message: "Running On Boarding...",
      });

      const responseonBoard = await onBoarding(
        storeId.value,
        responseRuijieV3.jobId
      );
      $q.notify({
        message: `${responseonBoard.message} ${responseonBoard.status} Job ID: ${responseonBoard.jobId}`,
        color: "accent",
        position: "top",
      });
    }
    insertWorkconnectLog(
      `Provision ${storeId.value} ${ipAdd} ${routerType}`,
      201,
      "fe-provision",
      storeId.value
    );
    $q.notify({
      message: `Successfully Provisioned! ${storeId.value}`,
      color: "accent",
      position: "top",
    });
  } catch (error: any) {
    if (error.response && error.response.data && error.response.data.error) {
      const errorMessage = error.response.data.error;
      $q.notify({
        message: errorMessage,
        color: "negative",
        position: "top",
      });
    }
  } finally {
    $q.loading.hide();
  }
};

const offBoarding = async () => {
  $q.loading.show({
    message: `Off Boarding ${storeId.value}`,
  });
  try {
    await offBoardingStore(storeId.value);
    console.log(storeId.value);
    insertWorkconnectLog(
      `Off Boarding ${storeId.value}`,
      200,
      "fe-offboarding",
      storeId.value
    );
    $q.notify({
      message: "Successfully Off boarded " + storeId.value,
      color: "accent",
      actions: [
        {
          icon: "close",
          color: "white",
          round: true,
          handler: () => {},
        },
      ],
    });
  } catch (error: any) {
    if (error.response && error.response.data && error.response.data.error) {
      const errorMessage = error.response.data.error;
      $q.notify({
        message: errorMessage,
        color: "negative",
        position: "top",
      });
    }
  } finally {
    $q.loading.hide();
  }
};

const onUpdateStoreStatus = async () => {
  $q.loading.show({
    message: `Updating Store Status ${storeId.value}`,
  });
  try {
    await updateStoreStatus(storeId.value, status.value);
    insertWorkconnectLog(
      `Update Store Status ${storeId.value} ${status.value}`,
      200,
      "fe-update-status",
      storeId.value
    );
    $q.notify({
      message: "Successfully Update Store Status " + storeId.value,
      color: "accent",
      actions: [
        {
          icon: "close",
          color: "white",
          round: true,
          handler: () => {},
        },
      ],
    });
  } catch (error: any) {
    if (error.response && error.response.data && error.response.data.error) {
      const errorMessage = error.response.data.error;
      $q.notify({
        message: errorMessage,
        color: "negative",
        position: "top",
      });
    }
  } finally {
    $q.loading.hide();
  }
};
const onReset = () => {
  storeId.value = "";
  ipAdd.value = "";
  status.value = "";
};

const isValidIPAddress = (ipAddress: string) => {
  const ipv4Pattern =
    /^((25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})\.){3}(25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})$/;

  return ipv4Pattern.test(ipAddress);
};
watch(boardingType, () => {
  console.log(boardingType.value);
});
</script>

<style scoped></style>
