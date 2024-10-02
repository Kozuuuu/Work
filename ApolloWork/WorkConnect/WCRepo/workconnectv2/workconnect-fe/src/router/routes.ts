// @ts-ignore
// if (keycloak.value.realmAccess.roles.includes(authority))

const routes = [
  {
    path: "/",
    redirect: "/Dashboard",
    component: () => import("src/layouts/MainLayout.vue"),

    children: [
      {
        path: "/Dashboard",
        component: () => import("pages/Dashboard.vue"),
        name: "Down Dashboard",
        meta: {
          icon: "dashboard",
          roles: [
            "GROUP_APOLLO_PROD_SUPPORT",
            "GROUP_APOLLO_OPERATIONS",
            "GROUP_SUPERADMIN",
            "GROUP_PSC_USERS",
          ],
        },
      },
      {
        path: "/Down-Circuits",
        component: () => import("pages/DownCircuits.vue"),
        name: "Down Circuits",
        meta: {
          icon: "router",
          roles: [
            "GROUP_APOLLO_PROD_SUPPORT",
            "GROUP_APOLLO_OPERATIONS",
            "GROUP_SUPERADMIN",
          ],
        },
      },
      {
        path: "/Stores",
        component: () => import("pages/Sites.vue"),
        name: "Stores",
        meta: {
          icon: "location_on",
          roles: [
            "GROUP_APOLLO_PROD_SUPPORT",
            "GROUP_APOLLO_OPERATIONS",
            "GROUP_SUPERADMIN",
            "GROUP_PSC_USERS",
            "ROLE_CLIQQ_REPORTS",
          ],
        },
        children: [
          {
            name: "Store Id",
            path: ":storeId",
            component: () => import("src/components/storeInfo/StoreInfo.vue"),
            // props: true,
            meta: {
              roles: ["any"],
            },
          },
          // {
          //   path: "/:pathMatch(.*)*",
          //   redirect: "/Dashboard",
          //   meta: { roles: ["any"] },
          // },
        ],
      },
      {
        path: "/CircuitProviderReport",
        component: () => import("pages/CircuitProviderReport.vue"),
        name: "Circuit Provider Report",
        meta: {
          icon: "trending_up",
          roles: [
            "GROUP_APOLLO_PROD_SUPPORT",
            "GROUP_APOLLO_OPERATIONS",
            "GROUP_SUPERADMIN",
          ],
        },
      },
      {
        path: "/CliqqWifiReport",
        component: () => import("pages/CliqqWifiReport.vue"),
        name: "Cliqq Wifi Report",
        meta: {
          icon: "trending_up",
          roles: ["GROUP_PSC_USERS", "ROLE_CLIQQ_REPORTS"],
        },
      },
      {
        path: "/StoreStatusReport",
        component: () => import("pages/Reports.vue"),
        name: "Store Status Report",
        meta: {
          icon: "summarize",
          roles: [
            "GROUP_APOLLO_PROD_SUPPORT",
            "GROUP_APOLLO_OPERATIONS",
            "GROUP_SUPERADMIN",
          ],
        },
      },
      {
        path: "/ZabbixReport",
        component: () => import("pages/ZabbixReports.vue"),
        name: "Zabbix Report",
        meta: {
          icon: "summarize",
          roles: ["GROUP_APOLLO_PROD_SUPPORT", "GROUP_APOLLO_OPERATIONS"],
        },
      },
      // {
      //   path: "/History",
      //   component: () => import("pages/CountHistory.vue"),
      //   name: "History",
      //   meta: { icon: "trending_up", roles: ["any"] },
      // },
      //{
      //  path: "/Mindanao",
      //  component: () => import("pages/Mindanao.vue"),
      //   name: "Mindanao",
      //  meta: {
      //    icon: "forest",
      //    roles: [
      //      "GROUP_APOLLO_PROD_SUPPORT",
      //      "GROUP_APOLLO_OPERATIONS",
      //      "GROUP_SUPERADMIN",
      //    ],
      //  },
      //},
      {
        path: "/Provision",
        component: () => import("pages/Boarding.vue"),
        name: "Provisioning",
        meta: { icon: "add_circle", roles: ["ROLE_PLAYBOOK_PAGE"] },
      },
      {
        path: "/activities",
        component: () => import("pages/Logs.vue"),
        name: "Activity Log",
        meta: { icon: "list", roles: ["ROLE_ACTIVITY_LOG"] },
      },
      {
        path: "/circuitslog",
        component: () => import("pages/CircuitLogs.vue"),
        name: "Circuits Log",
        meta: { icon: "cable", roles: ["ROLE_ACTIVITY_LOG"] },
      },
      // {
      //   path: "/vpn-server",
      //   component: () => import("pages/VpnMonitoring.vue"),
      //   name: "VPN Server",
      //   meta: {
      //     icon: "dns",
      //     roles: ["GROUP_APOLLO_PROD_SUPPORT", "GROUP_APOLLO_OPERATIONS"],
      //   },
      // },
    ],
  },
  // {
  //   path: "/Login",
  //   component: () => import("pages/Landing.vue"),
  //   name: "Login",
  //   roles: ["any"],
  // },
  // Always leave this as last one,
  // but you can also remove it
  //{
  //  path: '/:catchAll(.*)*',
  //  component: () => import('pages/Error404.vue')
  //},
  {
    path: "/404",
    component: () => import("src/pages/ErrorNotFound.vue"),
    meta: { roles: ["any"] },
  },
  {
    path: "/:pathMatch(.*)*",
    component: () => import("src/pages/ErrorNotFound.vue"),
    meta: { roles: ["any"] },
  },
];

export default routes;
