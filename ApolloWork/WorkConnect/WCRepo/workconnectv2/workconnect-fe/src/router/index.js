import { route } from "quasar/wrappers";
import {
  createRouter,
  createMemoryHistory,
  createWebHistory,
  createWebHashHistory,
} from "vue-router";
import routes from "./routes";
import { auth } from "src/stores/auth";

export default route(function ({ keycloak, store }) {
  const createHistory =
    process.env.MODE === "ssr"
      ? createMemoryHistory
      : process.env.VUE_ROUTER_MODE === "history"
      ? createWebHistory
      : createWebHashHistory;

  const Router = createRouter({
    scrollBehavior: () => ({ left: 0, top: 0 }),
    routes,

    // Leave this as is and make changes in quasar.conf.js instead!
    // quasar.conf.js -> build -> vueRouterMode
    // quasar.conf.js -> build -> publicPath
    history: createHistory(
      process.env.MODE === "ssr" ? void 0 : process.env.VUE_ROUTER_BASE
    ),
  });
  // Router.beforeEach(async (to, from, next) => {
  //   const isAuthenticated = store.state.value.keycloak.keycloak.authenticated;

  //   // Check if the user is authenticated
  //   if (isAuthenticated) {
  //     const routeRoles = to.meta.roles || [];
  //     const hasRequiredRoles = routeRoles.some((role) =>
  //       store.state.value.keycloak.keycloak.hasRealmRole(role)
  //     );

  //     // // Check if the destination route is "/CliqqWifiReport" and if so, proceed without redirection
  //     if (to.path === "/CliqqWifiReport") {
  //       next();
  //       return; // Exit the navigation guard after allowing navigation to the desired page
  //     }

  //     console.log(routeRoles);
  //     if (store.state.value.keycloak.keycloak.hasRealmRole("GROUP_PSC_USERS")) {
  //       console.log("You are a psc user");
  //       next("/CliqqWifiReport");

  //       return;
  //     }

  //     if (
  //       !hasRequiredRoles &&
  //       !routeRoles.includes("any") &&
  //       to.path !== "/401" &&
  //       routeRoles.length > 0
  //     ) {
  //       next("/401");
  //       return;
  //     }

  //     // Redirect to home if trying to access Login page while already authenticated
  //     if (to.path === "/Login") {
  //       next({ path: "/" });
  //       return; // Exit the navigation guard after redirection
  //     }
  //   } else {
  //     // Redirect to Login if not authenticated and trying to access other pages
  //     if (to.path !== "/Login") {
  //       next({ path: "/Login" });
  //       return; // Exit the navigation guard after redirection
  //     }
  //   }

  //   next(); // Continue navigation to the desired page if no redirection is needed
  // });

  // Router.beforeEach(async (to, from, next) => {
  //   const isAuthenticated = store.state.value.keycloak.keycloak.authenticated;

  //   // Check if the user is authenticated
  //   if (isAuthenticated) {
  //     const routeRoles = to.meta.roles || [];
  //     const hasRequiredRoles = routeRoles.some((role) =>
  //       store.state.value.keycloak.keycloak.hasRealmRole(role)
  //     );

  //     // Redirect to home if trying to access Login page while already authenticated
  //     if (to.path === "/Login") {
  //       next({ path: "/" });
  //       return;
  //     }

  //     // Redirect to '/401' path if the user doesn't have the required roles
  //     if (
  //       !hasRequiredRoles &&
  //       !routeRoles.includes("any") &&
  //       to.path !== "/401" &&
  //       routeRoles.length > 0
  //     ) {
  //       next("/401");
  //       return;
  //     }

  //     // Redirect to '/CliqqWifiReport' if the user has the required role
  //     if (
  //       routeRoles.includes("GROUP_PSC_USERS") &&
  //       to.path !== "/CliqqWifiReport"
  //     ) {
  //       next("/CliqqWifiReport");
  //       return;
  //     }
  //   } else {
  //     // Redirect to Login if not authenticated and trying to access other pages
  //     if (to.path !== "/Login") {
  //       next({ path: "/Login" });
  //       return;
  //     }
  //   }

  //   next(); // Continue navigation to the desired page if no redirection is needed
  // });

  // Router.beforeEach(async (to, from, next) => {
  //   const isAuthenticated = store.state.value.keycloak.keycloak.authenticated;

  //   if (isAuthenticated) {
  //     const routeRoles = to.meta.roles || [];
  //     const hasRequiredRoles = routeRoles.some((role) =>
  //       store.state.value.keycloak.keycloak.hasRealmRole(role)
  //     );

  //     // Redirect to '/CliqqWifiReport' if the user has the required role
  //     if (
  //       store.state.value.keycloak.keycloak.hasRealmRole("GROUP_PSC_USERS") &&
  //       to.path !== "/CliqqWifiReport" // Add this condition to prevent infinite loop
  //     ) {
  //       next("/CliqqWifiReport");
  //       return; // Exit the navigation guard after redirection
  //     } else if (
  //       !store.state.value.keycloak.keycloak.hasRealmRole("GROUP_PSC_USERS") &&
  //       to.path !== "/Dashboard"
  //     ) {
  //       next();
  //     } else {
  //       next();
  //     }

  //     if (
  //       !hasRequiredRoles &&
  //       !routeRoles.includes("any") &&
  //       to.path !== "/401" &&
  //       routeRoles.length > 0
  //     ) {
  //       next("/401"); // Redirect to '/401' path
  //       return; // Exit the navigation guard after redirection
  //     }

  //     // Redirect to home if trying to access Login page while already authenticated
  //     if (to.path === "/Login") {
  //       next({ path: "/" });
  //       return; // Exit the navigation guard after redirection
  //     }
  //   } else {
  //     // Redirect to Login if not authenticated and trying to access other pages
  //     if (to.path !== "/Login") {
  //       next({ path: "/Login" });
  //       return; // Exit the navigation guard after redirection
  //     }
  //   }

  //   next(); // Continue navigation to the desired page if no redirection is needed
  // });
  Router.beforeEach(async (to, from, next) => {
    const isAuthenticated = store.state.value.keycloak.keycloak.authenticated;

    if (isAuthenticated) {
      const routeRoles = to.meta.roles || [];
      const hasRequiredRoles = routeRoles.some((role) =>
        store.state.value.keycloak.keycloak.hasRealmRole(role)
      );

      // if (store.state.value.keycloak.keycloak.hasRealmRole("GROUP_PSC_USERS")) {
      //   Router.options.routes[0] = [];
      //   Router.options.routes[0] = {
      //     path: "/",
      //     redirect: "/CliqqWifiReport",
      //     component: () => import("src/layouts/MainLayout.vue"),
      //     children: [
      //       {
      //         path: "/Dashboard",
      //         component: () => import("pages/Dashboard.vue"),
      //         name: "Down Dashboard",
      //         meta: {
      //           icon: "dashboard",
      //           roles: ["GROUP_PSC_USERS"],
      //         },
      //       },
      //       {
      //         path: "/Stores",
      //         component: () => import("pages/Sites.vue"),
      //         name: "Stores",
      //         meta: {
      //           icon: "location_on",
      //           roles: [
      //             "GROUP_APOLLO_PROD_SUPPORT",
      //             "GROUP_APOLLO_OPERATIONS",
      //             "GROUP_SUPERADMIN",
      //             "GROUP_PSC_USERS",
      //             "ROLE_CLIQQ_REPORTS",
      //           ],
      //         },
      //         children: [
      //           {
      //             name: "Store Id",
      //             path: ":storeId",
      //             component: () =>
      //               import("src/components/storeInfo/StoreInfo.vue"),
      //             // props: true,
      //             meta: {
      //               roles: ["any"],
      //             },
      //           },
      //         ],
      //       },
      //       {
      //         path: "/CliqqWifiReport",
      //         component: () => import("pages/CliqqWifiReport.vue"),
      //         name: "Cliqq Wifi Report",
      //         meta: {
      //           icon: "trending_up",
      //           roles: ["GROUP_PSC_USERS", "ROLE_CLIQQ_REPORTS"],
      //         },
      //       },
      //     ],
      //   };
      // }
      // console.log(Router.options.routes[0]);
      if (
        !hasRequiredRoles &&
        !routeRoles.includes("any") &&
        to.path !== "/404" &&
        routeRoles.length > 0
      ) {
        // Redirect to '/CliqqWifiReport' if the user has the required role
        // if (
        //   store.state.value.keycloak.keycloak.hasRealmRole("GROUP_PSC_USERS") &&
        //   to.path !== "/CliqqWifiReport" // Add this condition to prevent infinite loop
        // ) {
        //   next("/CliqqWifiReport");
        //   return; // Exit the navigation guard after redirection
        // }

        next("/404"); // Redirect to '/401' path
        return; // Exit the navigation guard after redirection
      }
    }
    //  else {
    //   // Redirect to Login if not authenticated and trying to access other pages
    //   if (to.path !== "/Login") {
    //     next({ path: "/Login" });
    //     return; // Exit the navigation guard after redirection
    //   }
    // }

    next(); // Continue navigation to the desired page if no redirection is needed
  });

  return Router;
});

export const asyncRoutes = [{ path: "*", redirect: "/error/404" }];
