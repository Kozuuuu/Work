<template>
  <div class="q-px-none q-py-md">
    <q-btn class="text-dark" round color="primary">
      <q-avatar size="40px">
        <q-icon name="account_circle" color="grey-3" />
      </q-avatar>
      <q-menu>
        <q-list bordered>
          <q-item v-ripple>
            <q-item-section avatar>
              <q-avatar
                color="teal"
                text-color="white"
                icon="account_circle"
              ></q-avatar>
            </q-item-section>

            <q-item-section>
              <q-item-label>{{ getName }}</q-item-label>
              <q-item-label caption lines="1">{{
                UserProfile.username
              }}</q-item-label>
            </q-item-section>
          </q-item>
          <q-separator></q-separator>

          <!--
      <q-item clickable v-ripple>
        <q-item-section avatar>
          <q-avatar color="teal" text-color="white" icon="settings"></q-avatar>
        </q-item-section>

        <q-item-section>Settings</q-item-section>
      </q-item>
      -->
          <!-- <q-item clickable v-ripple @click="changePassword = true">
            <q-item-section avatar>
              <q-avatar
                rounded
                color="negative"
                text-color="white"
                icon="manage_accounts"
              ></q-avatar>
            </q-item-section>
            <q-item-section>Change Password</q-item-section>
          </q-item> -->

          <q-item clickable v-ripple v-close-popup @click="logout()">
            <q-item-section avatar>
              <q-avatar
                rounded
                color="purple"
                text-color="white"
                icon="logout"
              ></q-avatar>
            </q-item-section>
            <q-item-section>Logout</q-item-section>
          </q-item>
        </q-list>
      </q-menu>
    </q-btn>
  </div>

  <div>
    <q-dialog
      v-model="changePassword"
      class="q-pa-md q-gutter-sm"
      persistent
      label="Change Password"
    >
      <q-card class="q-pa-lg col-md-8">
        <div class="text-h5 q-pa-lg q-col-12 q-mb-md">Change Password</div>
        <q-card-section class="col items-center">
          <q-item>
            <q-item-section>
              <q-input
                dense
                label=""
                :type="isPwd ? 'password' : 'text'"
                v-model="passwordList.oldPassword"
                :rules="[rules.requiredField]"
              >
                <template v-slot:label>
                  <div>Current Password <span class="text-red">*</span></div>
                </template>
                <template v-slot:append>
                  <q-icon
                    :name="isPwd ? 'visibility_off' : 'visibility'"
                    class="cursor-pointer"
                    @click="isPwd = !isPwd"
                  ></q-icon>
                </template>
              </q-input>
            </q-item-section>
          </q-item>
          <q-item>
            <q-item-section>
              <q-input
                dense
                label=""
                :type="isNewPwd ? 'password' : 'text'"
                v-model="passwordList.newPassword"
                :rules="[
                  rules.requiredField,
                  rules.passwordHasLowerCase,
                  rules.passwordHasUpperCase,
                  rules.passwordHasNumber,
                  rules.passwordHasSpecialCharacters,
                  rules.passwordLenght,
                ]"
              >
                <template v-slot:label>
                  <div>New Password <span class="text-red">*</span></div>
                </template>
                <template v-slot:append>
                  <q-icon
                    :name="isNewPwd ? 'visibility_off' : 'visibility'"
                    class="cursor-pointer"
                    @click="isNewPwd = !isNewPwd"
                  ></q-icon>
                </template>
              </q-input>
            </q-item-section>
          </q-item>
          <q-item>
            <q-item-section>
              <q-input
                dense
                label=""
                :type="isPwdConfirm ? 'password' : 'text'"
                v-model="passwordList.confirmPassword"
                :rules="[
                  rules.requiredField,
                  rules.matchPassword,
                  rules.passwordLenght,
                ]"
              >
                <template v-slot:label>
                  <div>Confirm Password <span class="text-red">*</span></div>
                </template>
                <template v-slot:append>
                  <q-icon
                    :name="isPwdConfirm ? 'visibility_off' : 'visibility'"
                    class="cursor-pointer"
                    @click="isPwdConfirm = !isPwdConfirm"
                  ></q-icon>
                </template>
              </q-input>
            </q-item-section>
          </q-item>
        </q-card-section>

        <q-card-actions align="center">
          <q-btn
            class="lg-6 row-md-6 col-sm-4 mb-lg"
            flat
            label="Cancel"
            @click="clearFields"
            color="primary"
          />
          <!-- <q-btn
            class="q-pa-xs"
            label="Change Password"
            @click="submitChangePassword"
            :disable="!validPwdForm"
            color="primary"
          /> -->
        </q-card-actions>
      </q-card>
    </q-dialog>
  </div>
</template>

<script>
import { ref, computed } from "vue";
import { useQuasar } from "quasar";

import { auth } from "stores/auth";
import { storeToRefs } from "pinia";
// import api from "/src/api/API.js";

export default {
  setup() {
    const $q = useQuasar();
    const store = auth();
    const { getName, UserProfile } = storeToRefs(store);
    const changePassword = ref(false);

    const isPwdConfirm = ref(true);
    const isPwd = ref(true);
    const isNewPwd = ref(true);

    const passwordList = ref({
      userName: String,
      oldPassword: undefined,
      newPassword: undefined,
      confirmPassword: undefined,
    });

    const validPwdForm = computed(() => {
      passwordList.value.userName = UserProfile.value.username;
      return (
        passwordList.value.oldPassword &&
        passwordList.value.newPassword &&
        passwordList.value.confirmPassword &&
        rules.value.requiredField(passwordList.value.newPassword) == true &&
        rules.value.requiredField(passwordList.value.oldPassword) == true &&
        rules.value.requiredField(passwordList.value.confirmPassword) == true &&
        rules.value.matchPassword(
          passwordList.value.newPassword,
          passwordList.value.confirmPassword
        ) == true &&
        rules.value.passwordLenght(passwordList.value.confirmPassword) ==
          true &&
        rules.value.passwordLenght(passwordList.value.newPassword) == true &&
        rules.value.passwordHasSpecialCharacters(
          passwordList.value.newPassword
        ) == true &&
        rules.value.passwordHasUpperCase(passwordList.value.newPassword) ==
          true &&
        rules.value.passwordHasLowerCase(passwordList.value.newPassword) ==
          true &&
        rules.value.passwordHasNumber(passwordList.value.newPassword) == true
      );
    });

    const rules = ref({
      requiredField: (v) => !!v || "Required field.",
      matchPassword: (v) =>
        v === passwordList.value.newPassword || "Does not match new password.",
      passwordLenght: (v) =>
        !v || /^.{8,}$/.test(v) || "Password cannot be less than 8 characters.",
      passwordHasSpecialCharacters: (v) =>
        !v ||
        /[!@#$%^&*(),.?":{}|<>]/.test(v) ||
        "Password must have special characters.",
      passwordHasUpperCase: (v) =>
        !v || /[A-Z]/.test(v) || "Password must have upper case characters.",
      passwordHasLowerCase: (v) =>
        !v || /[a-z]/.test(v) || "Password must have lower case characters.",
      passwordHasNumber: (v) =>
        !v || /[0-9]/.test(v) || "Password must have numerical characters.",
    });

    const clearFields = () => {
      passwordList.value.oldPassword = undefined;
      passwordList.value.newPassword = undefined;
      passwordList.value.confirmPassword = undefined;
      changePassword.value = false;
    };

    async function submitChangePassword() {
      console.log("passwordList", passwordList);
      await api
        .updatePassword(passwordList.value)
        .then((res) => {
          console.log(res);
          popup(res.error, res.status);
        })
        .catch((e) => {
          console.log(e);
          $q.notify({
            color: "negative",
            position: "top",
            message: "Logic Error " + e.error,
            timeout: 5,
            icon: "report_problem",
          });
        });
    }

    function popup(message, statusCode) {
      let title = "Change Password";
      $q.dialog({
        title: title,
        message: message,
        persistent: true,
      }).onOk(() => {
        clearFields();
      });
    }

    // $keycloak.logoutFn(logoutObject)
    return {
      validPwdForm,
      submitChangePassword,
      isNewPwd,
      clearFields,
      isPwd,
      isPwdConfirm,
      passwordList,
      rules,

      changePassword,
      getName,
      UserProfile,
      isDark: ref($q.dark.isActive),
      bluetooth: ref(false),

      logoutObject: ref({ logoutRedirectUri: window.location.host }),
    };
  },
  methods: {
    logout() {
      localStorage.clear();
      this.$keycloak.logoutFn({ logoutRedirectUri: window.location.host });
    },
  },
};
</script>
