import { defineStore } from 'pinia';

export const paymentmodule = defineStore('paymentmodule', {
  state: () => ({
    customerData: {},
    paymentMethod: {},
    account: {},
    token: undefined
  }),
  getters: {
    getCustomerData() {
      return this.$state.customerData;
    },
    getPaymentMethod() {
      return this.$state.paymentMethod;
    },
    getAccount() {
      return this.$state.account;
    },
    getToken() {
      return this.$state.token;
    },
  },
  actions: {
    async setOptions(value) {
      console.log("paymentmodule_setOptions",value.data)
      this.customerData = await value.data
      this.paymentMethod = await value.paymentMethod
      this.account = await value.account
      this.token = await value.token

      console.log("customerData",this.$state.customerData)
      console.log("paymentMethod",this.$state.paymentMethod)
      console.log("account",this.$state.account)
      console.log("token",this.$state.token)
    }
  },
});
