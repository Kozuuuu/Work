import { boot } from "quasar/wrappers";
import VueKeyCloak from "@dsb-norge/vue-keycloak-js";
import axios from "axios";
import { auth } from "stores/auth";
import { store as stores } from "src/utils/helper";
// import { useJwt } from "@vueuse/integrations/useJwt";
// import { getCLientIp } from "src/api/api";
const store = auth();

// console.log("KeycloakURL",process.env.VUE_APP_KEYCLOAK_URL)
// console.log("KeycloakRealm",process.env.VUE_APP_KEYCLOAK_REALM)
// console.log("KeycloakCLientId",process.env.VUE_APP_KEYCLOAK_CLIENT_ID)

export default boot(async ({ app, router }) => {
  async function tokenInterceptor() {
    axios.interceptors.request.use(
      (config) => {
        // config.headers.Authorization = `Bearer ${app.config.globalProperties.$keycloak.token}`;
        config.headers.Authorization = `${app.config.globalProperties.$keycloak.token}`;
        // const { ip } = getCLientIp();
        // config.headers.ClientIp = ip;
        stores.$state.authToken = app.config.globalProperties.$keycloak.token;

        // const encodedJwt = app.config.globalProperties.$keycloak.token;
        // const { header, payload } = useJwt(encodedJwt);
        config.url = process.env.VUE_APP_WORKCONNECT_API_URL + config.url;
        // console.log(header, payload);
        return config;
      },
      (error) => {
        return Promise.reject(error);
      }
    );
  }

  localStorage.realm = "login";

  if (localStorage.realm == "login") {
    return new Promise((resolve) => {
      localStorage.realm = "";
      app.use(VueKeyCloak, {
        init: {
          onLoad: "login-required", // or 'check-sso'
          // flow: 'standard',
          // pkceMethod: 'S256',//silentCheckSsoRedirectUri: window.location.origin + '/silent-check-sso.html',
          checkLoginIframe: false, // otherwise it would reload the window every so seconds
        },

        config: {
          url: process.env.VUE_APP_KEYCLOAK_URL,
          realm: process.env.VUE_APP_KEYCLOAK_REALM,
          clientId: process.env.VUE_APP_KEYCLOAK_CLIENT_ID,
        },
        onReady: (keycloak) => {
          tokenInterceptor();
          store.setKeycloak(keycloak);
          store.setUserProfile();
          // console.log(store);
          resolve();
        },
      });
    });
  } else {
    return new Promise((resolve) => {
      app.use(VueKeyCloak, {
        init: {
          onLoad: "check-sso", // or 'check-sso'
          // flow: 'standard',
          // pkceMethod: 'S256',//silentCheckSsoRedirectUri: window.location.origin + '/silent-check-sso.html',
          checkLoginIframe: false, // otherwise it would reload the window every so seconds
        },

        config: {
          url: process.env.VUE_APP_KEYCLOAK_URL,
          realm: process.env.VUE_APP_KEYCLOAK_REALM,
          clientId: process.env.VUE_APP_KEYCLOAK_CLIENT_ID,
        },
        onReady: (keycloak) => {
          tokenInterceptor();
          store.setKeycloak(keycloak);
          store.setUserProfile();
          console.log(store);
          resolve();
        },
      });
    });
  }
});
