<template>
  <q-form @submit="CreateUser()">
    <div class="q-pa-md">
      <q-breadcrumbs separator="---" active-color="secondary">
        <q-breadcrumbs-el
          label="Users"
          to="/UserManagement"
          icon="person"
          class="breadcrumbs"
        ></q-breadcrumbs-el>
        <q-breadcrumbs-el label="Registration"></q-breadcrumbs-el>
      </q-breadcrumbs>
    </div>
    <q-tabs v-model="tab" class="text-teal" dense>
      <q-tab name="user_information" icon="" label="USER INFORMATION" />
      <q-tab name="user_permission" icon="" label="USER PERMISSION" />
    </q-tabs>
    <q-tab-panels
      v-model="tab"
      animated
      swipeable
      vertical
      transition-prev="jump-up"
      transition-next="jump-up"
    >
      <q-tab-panel name="user_information">
        <q-list class="row">
          <q-item class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
            <q-item-section>
              <q-input
                :options="['Importer/Exporter']"
                dense
                label=""
                v-model="userDetails.firstName"
                :rules="[rules.requiredField]"
              >
                <template v-slot:label>
                  <div>First Name <span class="text-red">*</span></div>
                </template>
              </q-input>
            </q-item-section>
          </q-item>
          <q-item class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
            <q-item-section>
              <q-input
                dense
                label=""
                v-model="userDetails.lastName"
                :rules="[rules.requiredField]"
              >
                <template v-slot:label>
                  <div>Last Name <span class="text-red">*</span></div>
                </template>
              </q-input>
            </q-item-section>
          </q-item>
          <q-item class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
            <q-item-section>
              <q-input
                dense
                label=""
                v-model="userDetails.middleName"
                :rules="[rules.requiredField]"
              >
                <template v-slot:label>
                  <div>Middle Name <span class="text-red">*</span></div>
                </template>
              </q-input>
            </q-item-section>
          </q-item>
          <q-item class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
            <q-item-section>
              <q-input
                dense
                label=""
                v-model="userDetails.birthDate"
                :rules="[rules.requiredField]"
              >
                <template v-slot:label>
                  <div>Birth Date <span class="text-red">*</span></div>
                </template>
                <template v-slot:append>
                  <q-icon name="event" class="cursor-pointer">
                    <q-popup-proxy
                      ref="qDateProxy"
                      cover
                      transition-show="scale"
                      transition-hide="scale"
                    >
                      <q-date v-model="userDetails.birthDate" mask="YYYY-MM-DD">
                        <div class="row items-center justify-end">
                          <q-btn
                            v-close-popup
                            label="Close"
                            color="primary"
                            flat
                          ></q-btn>
                        </div>
                      </q-date>
                    </q-popup-proxy>
                  </q-icon>
                </template>
              </q-input>
            </q-item-section>
          </q-item>
          <q-item class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
            <q-item-section>
              <q-input
                dense
                label=""
                v-model="userDetails.mobileNumber"
                :rules="[rules.requiredField, rules.mobileNumber]"
              >
                <template v-slot:label>
                  <div>Mobile Number <span class="text-red">*</span></div>
                </template>
              </q-input>
            </q-item-section>
          </q-item>
          <q-item class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
            <q-item-section>
              <q-input
                dense
                label=""
                v-model="userDetails.email"
                :rules="[rules.requiredField, rules.properEmail]"
              >
                <template v-slot:label>
                  <div>Email Address <span class="text-red">*</span></div>
                </template>
              </q-input>
            </q-item-section>
          </q-item>
        </q-list>
        <div class="row q-pa-md text-center justify-center">
          <q-btn
            outline
            class="text-grey"
            label="Discard"
            v-close-popup
          ></q-btn>
          <q-btn color="primary" label="Next"></q-btn>
        </div>
      </q-tab-panel>
      <q-tab-panel name="user_permission">
        <q-card>
          <q-card-section class="text-h6 q-pa-sm">
            <div class="text-h6">USER PERMISSION</div>
          </q-card-section>
          <q-card-section>
            <q-list class="row">
              <q-item class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                <q-item-section>
                  <q-select
                    :options="RoleOptions"
                    multiple
                    use-chips
                    use-input
                    clearable
                    @filter="filterFn"
                    dense
                    label=""
                    v-model="selectedRoles"
                    :rules="[rules.requiredSelection]"
                    :loading="roleLoad"
                  >
                    <template v-slot:label>
                      <div>Roles <span class="text-red">*</span></div>
                    </template>
                  </q-select>
                </q-item-section>
              </q-item>
              <q-item class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                <q-item-section>
                  <q-input
                    dense
                    label=""
                    v-model="userinfo.username"
                    :rules="[rules.requiredField]"
                  >
                    <template v-slot:label>
                      <div>Username <span class="text-red">*</span></div>
                    </template>
                  </q-input>
                </q-item-section>
              </q-item>
              <q-item class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                <q-item-section>
                  <q-input
                    dense
                    label="Suggested Password"
                    readonly
                    v-model="generatedPassword"
                    class="q-pb-md"
                  >
                    <template v-slot:append>
                      <q-icon
                        name="content_copy"
                        class="cursor-pointer"
                        @click="copyToClipboard(generatedPassword)"
                      ></q-icon>
                    </template>
                  </q-input>
                </q-item-section>
              </q-item>
              <q-item class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                <q-item-section>
                  <q-input
                    dense
                    label=""
                    v-model="userinfo.password"
                    :type="isPwd ? 'password' : 'text'"
                    :rules="[rules.requiredField]"
                  >
                    <template v-slot:label>
                      <div>Password <span class="text-red">*</span></div>
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
              <q-item class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                <q-item-section>
                  <q-input
                    dense
                    label=""
                    v-model="userinfo.passwordConfirm"
                    :type="isPwdConfirm ? 'password' : 'text'"
                    :rules="[rules.requiredField, rules.matchPassword]"
                  >
                    <template v-slot:label>
                      <div>
                        Confirm Password <span class="text-red">*</span>
                      </div>
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
              <q-item class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                <q-item-section>
                  <q-toggle
                    v-model="userDetails.isEnabled"
                    label="Is Enabled"
                  ></q-toggle>
                </q-item-section>
              </q-item>
            </q-list>
          </q-card-section>
        </q-card>
        <div class="row q-pa-md q-gutter-sm text-center justify-center">
          <q-btn
            outline
            class="text-grey"
            label="Discard"
            v-close-popup
          ></q-btn>
          <q-btn
            color="primary"
            label="Save"
            type="submit"
            :loading="createLoad"
          ></q-btn>
        </div>
      </q-tab-panel>
    </q-tab-panels>
  </q-form>
</template>

<script>
import { defineComponent, defineAsyncComponent, ref, onMounted } from "vue";
import { copyToClipboard, useQuasar } from "quasar";
import { useRouter } from "vue-router";

// import api from "/src/api/API.js";

export default defineComponent({
  name: "User Registration",
  components: {
    ClientList: defineAsyncComponent(() =>
      import("components/tables/TableServerSide")
    ),
  },
  setup() {
    const router = useRouter();
    const $q = useQuasar();
    const userDetails = ref({ isEnabled: true });
    const userinfo = ref({});
    const selectedRoles = ref([]);
    const createLoad = ref(false);
    const roleLoad = ref(false);
    const clientLoad = ref(false);
    const clientList = ref([]);
    const roleList = ref([]);

    async function CreateUser() {
      createLoad.value = true;
      userDetails.value.role = formatRoleList(selectedRoles.value); //format roles to String
      await api
        .createUser(userDetails.value, userinfo.value)
        .then((res) => {
          console.log(res);
          createLoad.value = false;
          popup("Create User " + res.message, res.statusCode);
        })
        .catch((e) => {
          console.log(e);
          createLoad.value = false;
          popup(e.response.data.message, e.response.data.statusCode);
        });
    }

    function popup(message, statusCode) {
      let title = "Success";
      if (statusCode == "200" || statusCode == "201") title = "Success";
      else title = "Error " + statusCode;
      $q.dialog({
        title: title,
        message: message,
        persistent: true,
      }).onOk(() => {
        if (title == "Success") {
          router.push("/Users");
        }
      });
    }

    function formatRoleList(list) {
      try {
        var formattedRole = JSON.stringify(
          list.map((role) => ({ name: role })).map(({ name }) => ({ name }))
        );
        return formattedRole.replace(/"/g, '"');
      } catch (e) {
        return list.toString();
      }
    }

    const generatePassword = () => {
      let CharacterSet = "";
      let password = "";
      let size = 8;
      CharacterSet += "abcdefghijklmnopqrstuvwxyz";
      CharacterSet += "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
      CharacterSet += "0123456789";
      CharacterSet += "![]{}()%&*$#^~@|";
      for (let i = 0; i < size; i++) {
        password += CharacterSet.charAt(
          Math.floor(Math.random() * CharacterSet.length)
        );
      }
      return password;
    };

    async function getRoleList() {
      roleLoad.value = true;
      const data = await api.getAllRoles();
      roleList.value = data.roles;
      roleLoad.value = false;
    }
    async function getClientList() {
      clientLoad.value = true;
      const data = await api.getAllClients();
      clientList.value = data.clients;
      clientLoad.value = false;
    }

    onMounted(async () => {
      // get initial data from server (1st page)
      getRoleList();
      getClientList();
    });

    const RoleOptions = ref(roleList.value);

    return {
      tab: ref("user_information"),
      selectedRoles,
      userDetails,
      userinfo,
      formatRoleList,
      CreateUser,
      createLoad,
      roleLoad,
      clientLoad,
      roleList,
      clientList,
      RoleOptions,
      isPwd: ref(true),
      isPwdConfirm: ref(true),
      generatedPassword: ref(generatePassword()),
      rules: ref({
        requiredField: (v) => !!v || "Required field.",
        requiredSelection: (v) =>
          (!!v && v.length > 0) || "Required at least one selection",
        matchPassword: (v) =>
          v === userinfo.value.password || "Does not match new password.",
        properEmail: (v) =>
          !v ||
          /^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/.test(v) ||
          "E-mail must be valid. Ex. juandelacruz@apollo.com.ph",
        mobileNumber: (v) =>
          !v ||
          /^(09)\d{9}$/.test(v) ||
          "Mobile number must be valid. Ex. starts with (09) followed by xxxxxxxxx, where x = numeric character only",
      }),
      filterFn(val, update) {
        if (val === "") {
          update(() => {
            RoleOptions.value = roleList.value;
            // here you have access to "ref" which
            // is the Vue reference of the QSelect
          });
          return;
        }
        update(() => {
          const needle = val.toLowerCase();
          RoleOptions.value = roleList.value.filter(
            (v) => v.toLowerCase().indexOf(needle) > -1
          );
        });
      },
    };
  },
});
</script>
