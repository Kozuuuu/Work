import { defineStore } from "pinia";

export const auth = defineStore("keycloak", {
  state: () => ({
    UserProfile: {},
    keycloak: {},
    isNotClient: false,
  }),
  getters: {
    getName() {
      // console.log(this.$state.keycloak)
      if (this.$state.UserProfile.firstName != undefined) {
        if (this.$state.UserProfile.firstName.includes("@"))
          return (
            this.$state.UserProfile.firstName.split("@")[0] +
            " " +
            this.$state.UserProfile.lastName.split("@")[0]
          );
        else
          return (
            this.$state.UserProfile.firstName +
            " " +
            this.$state.UserProfile.lastName
          );
      } else return this.$state.UserProfile.username;
    },
  },
  actions: {
    setKeycloak(payload) {
      this.$state.keycloak = payload;
    },
    async setUserProfile(payload) {
      this.$state.UserProfile = await this.$state.keycloak.loadUserProfile();
      console.log(this.$state.UserProfile);
    },
  },
});
