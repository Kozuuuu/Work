<template>
  <div class="q-pa-md">
    <q-table
      title="Sites"
      class="my-sticky-column-table"
      :rows="rows"
      :columns="columns"
      row-key="id"
      v-model:selected="selected"
      dense
      :separator="separator"
      :filter="filter"
      :loading="loading"
      :pagination="{ rowsPerPage: 15 }"
      :rows-per-page-options="[10, 15, 50]"
    >
      <template v-slot:body-cell-isEnabled="props">
        <q-td :props="props">
          <q-badge color="green" :label="'true'" v-if="props.value" />
          <q-badge color="red" :label="'false'" v-else="props.value" />
        </q-td>
      </template>

      <template v-slot:body-cell-actions="props">
        <q-td :props="props">
          <q-btn
            class="q-mr-xs"
            round
            dense
            size="sm"
            icon="zoom_in"
            @click="viewForm(props)"
          />
          <q-btn
            class="q-mr-xs"
            round
            dense
            color="positive"
            size="sm"
            icon="edit"
            @click="editForm(props)"
          />
          <!-- <q-btn
            round
            dense
            color="red"
            size="sm"
            icon="delete"
            @click="DeleteRecord(props)"
          /> -->
        </q-td>
      </template>

      <template v-slot:top-right="props">
        <q-input
          outlined
          dense
          debounce="300"
          v-model="filter"
          placeholder="Search here..."
        >
          <template v-slot:append>
            <q-icon name="search" />
          </template>
        </q-input>

        <q-btn
          flat
          round
          dense
          :icon="props.inFullscreen ? 'fullscreen_exit' : 'fullscreen'"
          @click="props.toggleFullscreen"
        >
          <q-tooltip :disable="$q.platform.is.mobile" v-close-popup
            >{{ props.inFullscreen ? 'Exit Fullscreen' : 'Toggle Fullscreen' }}
          </q-tooltip>
        </q-btn>

        <q-btn
          flat
          round
          dense
          :icon="mode === 'grid' ? 'list' : 'grid_on'"
          @click="
            mode = mode === 'grid' ? 'list' : 'grid';
            separator = mode === 'grid' ? 'vertical' : 'horizontal';
          "
        >
          <q-tooltip :disable="$q.platform.is.mobile" v-close-popup
            >{{ mode === 'grid' ? 'Vertical' : 'Grid' }}
          </q-tooltip>
        </q-btn>

        <q-btn
          color="primary"
          icon-right="archive"
          no-caps
          @click="exportTable"
        />
      </template>

      <template v-slot:loading>
        <q-inner-loading showing color="primary" />
      </template>
    </q-table>
  </div>
</template>

<script setup>
import { ref, computed, watch, watchEffect } from 'vue';
import { exportFile, useQuasar, copyToClipboard } from 'quasar';
import api from 'src/api/API';

const $q = useQuasar();
const mode = ref(null);
const addTransaction = ref(true);
const submitting = ref(false);
const selected = ref([]);
const separator = ref('vertical');
const rows = ref([]);
const loading = ref(false);
const filter = ref('');
const formActive = ref(false);
const formType = ref('');
const agencies = ref([]);
let roleOptions = ref([]);
let subagencyOptions = ref([]);
let clientOptions = ref([]);
const updateTransaction = ref(false);
const isPwd = ref(true);
const isPwdConfirm = ref(true);
const generatedPassword = ref('');
const birthDateMenu = ref(false);
const birthDateDisp = ref('');
const passwordType = {
  password: String,
  confirmPassword: String,
};

const rules = ref({
  requiredField: (v) => !!v || 'Required field.',
  requiredSelection: (v) =>
    (!!v && v.length > 0) || 'Required at least one selection',
  matchPassword: (v) =>
    v === form.value.password || 'Does not match new password.',
  properEmail: (v) =>
    !v ||
    /^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/.test(v) ||
    'E-mail must be valid. Ex. juandelacruz@apollo.com.ph',
  mobileNumber: (v) =>
    !v ||
    /^(09)\d{9}$/.test(v) ||
    'Mobile number must be valid. Ex. starts with (09) followed by xxxxxxxxx, where x = numeric character only',
});

const form = ref({
  username: undefined,
  firstName: undefined,
  middleName: undefined,
  birthDate: undefined,
  birthDate2: undefined,
  lastName: undefined,
  isEnabled: undefined,
  password: undefined,
  passwordConfirm: undefined,
  email: undefined,
  mobileNumber: undefined,
  remarks: undefined,
  client: undefined,
  type: undefined,
  role: undefined,
  formType: undefined,
});

watchEffect(() => {
  if (form.value.birthDate2) {
    const date = new Date(form.value.birthDate2);
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    form.value.birthDate = `${year}-${month}-${day}`;
  }
});

watchEffect(() => {
  console.log('Formatted Birth Date:', form.value.birthDate);
});
const userTypes = ['client', 'sub-client'];
const columns = [
  {
    name: 'username',
    required: true,
    label: 'Site ID',
    align: 'left',
    field: (row) => row.username,
    format: (val) => `${val}`,
    sortable: true,
  },
  {
    align: 'left',
    label: 'Site Name',
    field: (row) => row.firstName,
    name: 'firstName',
    sortable: true,
  },
  {
    align: 'left',
    label: 'Tenant Name',
    field: (row) => row.lastName,
    name: 'lastName',
    sortable: true,
  },
  {
    align: 'left',
    label: 'Group',
    field: (row) => row.dateCreated,
    name: 'dateCreated',
    sortable: true,
  },
  {
    align: 'left',
    label: 'Region',
    field: (row) => row.isEnabled,
    name: 'isEnabled',
    sortable: true,
    slot: 'body-cell-isEnabled',
  },
  {
    name: 'actions',
    label: 'Network Status',
    align: 'center',
    style: 'width:0px;',
  },
  {
    name: 'actions',
    label: 'Site Status',
    align: 'center',
    style: 'width:0px;',
  },
];

const loadData = () => {
  loading.value = true;
  api
    .getUsers(0, 0, '')
    .then((response) => {
      console.log(response.users);
      const sortedUsers = response.users.sort((a, b) => {
        return new Date(b.dateCreated) - new Date(a.dateCreated);
      });
      console.log(sortedUsers);
      sortedUsers.forEach((user) => {
        const modifiedRoles = user.roles.map((role) => ({ name: role }));
        user.roles = modifiedRoles;
      });
      rows.value = sortedUsers;
      loading.value = false;
    })
    .catch(() => {
      loading.value = false;
      $q.notify({
        color: 'negative',
        position: 'top',
        message: 'Loading failed',
        icon: 'report_problem',
      });
    });
};
loadData();
async function setData() {
  try {
    api
      .getAllRoles()
      .then((response) => {
        console.log(response.roles);
        roleOptions.value = response.roles.map((name) => ({ name }));
        // console.log(agencyOptions.value)
      })
      .catch((e) => {
        console.log(e);
        return [];
      });
  } catch (e) {
    console.log(e);
    agencyOptions = computed(() => {
      return [];
    });
  }

  try {
    api
      .getAllClients()
      .then((response) => {
        console.log(response);
        if (response.clients) {
          clientOptions = computed(() => {
            return response.clients.map((option) => {
              return {
                label: option.description,
                value: option.code,
              };
            });
          });
        }
      })
      .catch((e) => {
        console.log(e);
        clientOptions = [];
      });
  } catch (e) {
    console.log(e);
    clientOptions = computed(() => {
      return [];
    });
  }
}
setData();
const addForm = () => {
  onReset();
  generatedPassword.value = generatePassword();
  console.log(generatePassword.value);
  form.value.isEnabled = false;
  form.value.formType = 'CREATED';
  formActive.value = true;
  addTransaction.value = true;
  updateTransaction.value = false;
};

const editForm = (val) => {
  generatedPassword.value = '';
  form.value = val.row;
  if (val.row.client) {
    form.value.client.label = val.row.client.companyName;
    form.value.client.value = val.row.client.companyCode;
  }
  console.log(form.value);
  form.value.formType = 'UPDATE';
  formActive.value = true;
  addTransaction.value = false;
  updateTransaction.value = true;
};

const viewForm = (val) => {
  generatedPassword.value = '';
  form.value = val.row;
  if (val.row.client) {
    form.value.client.label = val.row.client.companyName;
    form.value.client.value = val.row.client.companyCode;
  }
  console.log(form.value);
  form.value.formType = 'VIEW';
  formActive.value = true;
  addTransaction.value = false;
  updateTransaction.value = true;
};
// const DeleteRecord = (val) => {
//   $q.dialog({
//     title: 'Delete Record',
//     message: 'Are you sure you want to delete, profile: ' + val.row.FirstName + ' ' + val.row.MiddleName + '?',
//     cancel: true
//   }).onOk(() => {
//     api.delete('profiles/'+val.key)
//       .then((response) => {
//         loadData();
//         $q.notify({
//           color: 'green-4',
//           textColor: 'white',
//           icon: 'cloud_done',
//           message: 'Record has been deleted!'
//         })
//         submitting.value = false
//       })
//       .catch(() => {
//         $q.notify({
//           color: 'negative',
//           position: 'top',
//           message: 'deleting failed',
//           icon: 'report_problem'
//         })
//       })
//   })
// }
const generatePassword = () => {
  let CharacterSet = '';
  let password = '';
  let size = 8;
  CharacterSet += 'abcdefghijklmnopqrstuvwxyz';
  CharacterSet += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  CharacterSet += '0123456789';
  CharacterSet += '![]{}()%&*$#^~@|';
  for (let i = 0; i < size; i++) {
    password += CharacterSet.charAt(
      Math.floor(Math.random() * CharacterSet.length)
    );
  }
  return password;
};

const onSubmit = (val) => {
  // add

  let formBody = JSON.parse(JSON.stringify(form.value));

  formBody.client = form.value.client?.companyCode ?? null;

  console.log(formBody);
  //   return;
  if (addTransaction.value) {
    submitting.value = true;
    api
      .createUser(formBody)
      .then((response) => {
        // console.log(response);

        if (response.error) {
          $q.notify({
            color: 'negative',
            position: 'top',
            message: response.error.response?.data.message ?? 'Creation failed',
            icon: 'report_problem',
          });
          submitting.value = false;
        } else {
          $q.notify({
            // position: 'top',
            color: 'green-4',
            textColor: 'white',
            icon: 'cloud_done',
            position: 'top',
            message: 'User has been saved!',
          });
          submitting.value = false;
          formActive.value = false;
        }
      })
      .catch((e) => {
        submitting.value = false;
        formActive.value = false;
        $q.notify({
          color: 'negative',
          position: 'top',
          message: e.message ?? 'Saving Failed',
          icon: 'report_problem',
        });
      });
  } else {
    $q.dialog({
      title: 'Edit User',
      message: 'Are you sure you want to edit?',
      cancel: true,
    }).onOk(() => {
      submitting.value = true;
      api
        .updateUser(formBody)
        .then((response) => {
          if (response.error) {
            $q.notify({
              color: 'negative',
              position: 'top',
              message: response.error.response?.data.message ?? 'Edit Failed',
              icon: 'report_problem',
            });
            submitting.value = false;
          } else {
            $q.notify({
              // position: 'top',
              color: 'green-4',
              textColor: 'white',
              icon: 'cloud_done',
              position: 'top',
              message: 'User has been updated!',
            });
            submitting.value = false;
            formActive.value = false;
          }
        })
        .catch((z) => {
          submitting.value = false;
          formActive.value = false;
          $q.notify({
            position: 'top',
            color: 'negative',
            position: 'top',
            message: z.message ?? 'editing failed',
            icon: 'report_problem',
          });
        });
    });
  }
};

const onHide = () => {
  isPwd.value = true;
  loadData();
  setData();
};
const onReset = () => {
  for (let pI in form.value) form.value[pI] = null;
  loadData();
  setData();
};

function wrapCsvValue(val, formatFn, row) {
  let formatted = formatFn !== void 0 ? formatFn(val, row) : val;

  formatted =
    formatted === void 0 || formatted === null ? '' : String(formatted);

  formatted = formatted.split('"').join('""');
  /**
   * Excel accepts \n and \r in strings, but some other CSV parsers do not
   * Uncomment the next two lines to escape new lines
   */
  // .split('\n').join('\\n')
  // .split('\r').join('\\r')

  return `"${formatted}"`;
}

const exportTable = () => {
  // naive encoding to csv format
  const content = [columns.map((col) => wrapCsvValue(col.label))]
    .concat(
      rows.value.map((row) =>
        columns
          .map((col) =>
            wrapCsvValue(
              typeof col.field === 'function'
                ? col.field(row)
                : row[col.field === void 0 ? col.name : col.field],
              col.format,
              row
            )
          )
          .join(',')
      )
    )
    .join('\r\n');

  const status = exportFile('users-export.csv', content, 'text/csv');

  if (status !== true) {
    $q.notify({
      message: 'Browser denied file download...',
      color: 'negative',
      icon: 'warning',
    });
  }
};
</script>
