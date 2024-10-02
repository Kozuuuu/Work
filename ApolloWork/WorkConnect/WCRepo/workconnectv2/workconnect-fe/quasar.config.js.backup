/* eslint-env node */

/*
 * This file runs in a Node context (it's NOT transpiled by Babel), so use only
 * the ES6 features that are supported by your Node version. https://node.green/
 */

// Configuration for your app
// https://v2.quasar.dev/quasar-cli-vite/quasar-config-js

const { configure } = require("quasar/wrappers");
const path = require("path");

module.exports = configure(function (ctx) {
  require("dotenv").config();

  return {
    // https://v2.quasar.dev/quasar-cli/prefetch-feature
    // preFetch: true,

    // app boot file (/src/boot)
    // --> boot files are part of "main.js"
    // https://v2.quasar.dev/quasar-cli/boot-files
    boot: ["i18n", "axios", "keycloak"],

    // https://v2.quasar.dev/quasar-cli-vite/quasar-config-js#css
    css: ["app.css"],

    // https://github.com/quasarframework/quasar/tree/dev/extras
    extras: [
      // 'ionicons-v4', depricated
      // 'mdi-v5',
      "fontawesome-v6",
      // 'eva-icons',
      // 'themify',
      // 'line-awesome',
      // 'roboto-font-latin-ext', // this or either 'roboto-font', NEVER both!
      // 'material-symbols-outlined',
      "roboto-font", // optional, you are not bound to it
      "material-icons", // optional, you are not bound to it
    ],

    // Full list of options: https://v2.quasar.dev/quasar-cli-vite/quasar-config-js#build
    build: {
      target: {
        browser: ["es2019", "edge88", "firefox78", "chrome87", "safari13.1"],
        node: "node16",
      },

      vueRouterMode: "history", // available values: 'hash', 'history'
      // vueRouterBase,
      // vueDevtools,
      // vueOptionsAPI: false,

      // rebuildCache: true, // rebuilds Vite/linter/etc cache on startup

      // publicPath: '/',
      // analyze: true,
      // env: {
      //   VUE_APP_KEYCLOAK_REALM: "workconnect-staging",
      //   VUE_APP_KEYCLOAK_URL: "https://wcdssi.apolloglobal.net:8443/auth",
      //   VUE_APP_KEYCLOAK_CLIENT_ID: "apollo",

      //   VUE_APP_WORKCONNECT_API_URL: ctx.debug
      //     ? "http://202.60.10.144:7500"
      //     : ctx.prod
      //     ? "https://workconnectv2.apolloglobal.net:7500"
      //     : "http://localhost:7500",
      // },

      env: {
        VUE_APP_KEYCLOAK_REALM: ctx.debug
          ? "workconnect-staging"
          : ctx.prod
          ? "workconnect-prod"
          : "workconnect-staging",

        VUE_APP_KEYCLOAK_URL: ctx.debug
          ? "https://wcdssi.apolloglobal.net:8443/auth"
          : ctx.prod
          ? "https://wcdssi.apolloglobal.net:8443/auth"
          : "https://wcdssi.apolloglobal.net:8443/auth",
        // VUE_APP_KEYCLOAK_URL: ctx.debug
        //   ? "https://keycloak-dev.apolloglobal.net:7443/auth"
        //   : ctx.prod
        //   ? "https://workconnect.apolloglobal.net:8443/auth"
        //   : "https://wcdssi.apolloglobal.net:8443/auth",

        VUE_APP_KEYCLOAK_CLIENT_ID: "apollo",

        VUE_APP_WORKCONNECT_API_URL: ctx.debug
          ? "http://202.60.10.144:7500"
          : ctx.prod
          ? "https://workconnect.apolloglobal.net:7500"
          : "http://localhost:7500",

        VUE_APP_ELASTICSEARCH_URL: "http://192.168.43.60:5601/",

        VUE_APP_ACTION: ctx.debug
          ? "wc-cdo"
          : ctx.prod
          ? "wc-prod"
          : "wc-local",

        // VUE_APP_WORKCONNECT_API_URL: "http://202.60.10.144:7500",
      },
      // {
      //   VUE_APP_KEYCLOAK_REALM: "workconnect-staging",
      //   VUE_APP_KEYCLOAK_URL: "https://wcdssi.apolloglobal.net:8443/auth",
      //   VUE_APP_KEYCLOAK_CLIENT_ID: "apollo",
      //   VUE_APP_REGISTER_REALM: "GoFastCPARegistration",
      //   // VUE_APP_WORKCONNECT_API_URL: "http://202.60.10.144:7500",
      //   // VUE_APP_WORKCONNECT_API_URL:
      //   //   "http://workconnect-uat.apolloglobal.net:7600",
      //   // VUE_APP_WORKCONNECT_API_URL: "http://localhost:7500",
      //   VUE_APP_WORKCONNECT_API_URL: ctx.dev
      //     ? "http://localhost:7500"
      //     : "http://202.60.10.144:7500",
      //   VUE_APP_BASE_URL: "http://localhost:8080",
      //   VUE_APP_VUE_ROUTER_MODE: "history",
      //   VUE_APP_PAYMENT_BASE_URL: "https://gw-dashboard-sbx.payconnect.io",
      //   VUE_APP_PAYMENT_MERCHANTCODE: "gofast",
      //   VUE_APP_PAYMENT_MERCHANTSECRET: "d123e890-e62c-40db-839f-7311313f4fd3",
      //   VUE_APP_PAYMENT_BASE_URL: "https://gateway-fe.payconnect.io",
      //   VUE_APP_PAYMENT_MERCHANTCODE: "gofast",
      //   VUE_APP_PAYMENT_MERCHANTSECRET: "65e4324b-7ee9-4f61-bdd4-5c3a74034152",
      //   VUE_APP_WALLET_IS_ENABLED: "true",
      // },
      // rawDefine: {}
      // ignorePublicFolder: true,
      // minify: false,
      // polyfillModulePreload: true,
      // distDir

      // extendViteConf (viteConf) {},
      // viteVuePluginOptions: {},

      vitePlugins: [
        [
          "@intlify/vite-plugin-vue-i18n",
          {
            // if you want to use Vue I18n Legacy API, you need to set `compositionOnly: false`
            // compositionOnly: false,

            // you need to set i18n resource including paths !
            include: path.resolve(__dirname, "./src/i18n/**"),
          },
        ],
      ],
    },

    // Full list of options: https://v2.quasar.dev/quasar-cli-vite/quasar-config-js#devServer
    devServer: {
      https: true,
      port: 3000,
      open: false, // opens browser window automatically
    },

    // https://v2.quasar.dev/quasar-cli-vite/quasar-config-js#framework
    framework: {
      config: {},

      // iconSet: 'ionicons-v4', // Quasar icon set
      // lang: 'en-US', // Quasar language pack

      // For special cases outside of where the auto-import strategy can have an impact
      // (like functional components as one of the examples),
      // you can manually specify Quasar components/directives to be available everywhere:
      //
      // components: [],
      // directives: [],

      // Quasar plugins
      plugins: ["AppFullscreen", "Dialog", "Notify", "Loading", "LoadingBar"],
    },

    // animations: 'all', // --- includes all animations
    // https://v2.quasar.dev/options/animations
    animations: [],

    // https://v2.quasar.dev/quasar-cli-vite/quasar-config-js#property-sourcefiles
    // sourceFiles: {
    //   rootComponent: 'src/App.vue',
    //   router: 'src/router/index',
    //   store: 'src/store/index',
    //   registerServiceWorker: 'src-pwa/register-service-worker',
    //   serviceWorker: 'src-pwa/custom-service-worker',
    //   pwaManifestFile: 'src-pwa/manifest.json',
    //   electronMain: 'src-electron/electron-main',
    //   electronPreload: 'src-electron/electron-preload'
    // },

    // https://v2.quasar.dev/quasar-cli/developing-ssr/configuring-ssr
    ssr: {
      // ssrPwaHtmlFilename: 'offline.html', // do NOT use index.html as name!
      // will mess up SSR

      // extendSSRWebserverConf (esbuildConf) {},
      // extendPackageJson (json) {},

      pwa: false,

      // manualStoreHydration: true,
      // manualPostHydrationTrigger: true,

      prodPort: 3000, // The default port that the production server should use
      // (gets superseded if process.env.PORT is specified at runtime)

      middlewares: [
        "render", // keep this as last one
      ],
    },

    // https://v2.quasar.dev/quasar-cli/developing-pwa/configuring-pwa
    pwa: {
      workboxMode: "generateSW", // or 'injectManifest'
      injectPwaMetaTags: true,
      swFilename: "sw.js",
      manifestFilename: "manifest.json",
      useCredentialsForManifestTag: false,
      // useFilenameHashes: true,
      // extendGenerateSWOptions (cfg) {}
      // extendInjectManifestOptions (cfg) {},
      // extendManifestJson (json) {}
      // extendPWACustomSWConf (esbuildConf) {}
    },

    // Full list of options: https://v2.quasar.dev/quasar-cli/developing-cordova-apps/configuring-cordova
    cordova: {
      // noIosLegacyBuildFlag: true, // uncomment only if you know what you are doing
    },

    // Full list of options: https://v2.quasar.dev/quasar-cli/developing-capacitor-apps/configuring-capacitor
    capacitor: {
      hideSplashscreen: true,
    },

    // Full list of options: https://v2.quasar.dev/quasar-cli/developing-electron-apps/configuring-electron
    electron: {
      // extendElectronMainConf (esbuildConf)
      // extendElectronPreloadConf (esbuildConf)

      inspectPort: 5858,

      bundler: "packager", // 'packager' or 'builder'

      packager: {
        // https://github.com/electron-userland/electron-packager/blob/master/docs/api.md#options
        // OS X / Mac App Store
        // appBundleId: '',
        // appCategoryType: '',
        // osxSign: '',
        // protocol: 'myapp://path',
        // Windows only
        // win32metadata: { ... }
      },

      builder: {
        // https://www.electron.build/configuration/configuration

        appId: "quasar-admin2",
      },
    },

    // Full list of options: https://v2.quasar.dev/quasar-cli-vite/developing-browser-extensions/configuring-bex
    bex: {
      contentScripts: ["my-content-script"],

      // extendBexScriptsConf (esbuildConf) {}
      // extendBexManifestJson (json) {}
    },
  };
});
