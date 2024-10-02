<template>
    <div class="text-center">
      <q-dialog v-model="dialog" persistent width="300">
        <q-card class="bg-primary text-white">
          <q-card-section class="pa-5">
            <h3 class="mb-5" v-if="displayHtml" v-html="loadingMessage"></h3>
            <h3 class="mb-5" v-else>{{ loadingMessage }}</h3>
            <q-linear-progress v-if="!finishLoading" color="white" class="mb-0" indeterminate></q-linear-progress>  
            <q-col class="text-center" v-if="finishLoading">
              <q-btn v-if="finishLoading" color="white" @click.stop="close" id="OK-id">OK</q-btn>
            </q-col>
          </q-card-section>
        </q-card>
      </q-dialog>
    </div>
  </template>
  
  <script>
  import { exportFile, useQuasar } from "quasar";
  export default {
    props: {
      isShow: Boolean,
      message: String,
      redirect: String,
      isHtml: {
        type: Boolean,
        default: false,
      },
      isDone: {
        type: Boolean,
        default: false,
      },
    },
    watch: {
      isShow: {
        handler(value) {
          this.dialog = value;
        },
      },
      isDone: {
        handler(value) {
          this.finishLoading = value;
        },
      },
      message: {
        handler(value) {
          this.loadingMessage = value;
        },
      },
      redirect: {
        handler(value) {
          this.redirectValue = value;
        },
      },
      isHtml: {
        handler(value) {
          this.displayHtml = value;
        },
      },

    },
    data() {
      return {
        dialog: this.isShow ?? false,
        finishLoading: this.isDone ?? false,
        loadingMessage: this.message ?? "Please stand by",
        displayHtml: this.isHtml ?? false,
        redirectValue: this.redirect ?? "",
        $q : useQuasar(),
      };
    },
    mounted() {
      console.log(this.redirect);
    },
    methods: {
      close() {
        this.dialog = false;
        if (this.displayHtml) {
          if (this.redirectValue) {
            this.$emit("redirect-value", this.redirectValue);
          } else {
            this.$emit("close-dialog", "loading");
          }
        } else {
          this.$emit("close-dialog", "loading-error");
        }
      },
    },
  };
  </script>
  