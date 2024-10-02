import axios, { AxiosResponse } from "axios";
import {
  prometheusDataReturn,
  nmsDataReturn,
  DetailsList,
  IstoreProfile,
  IcountAllStore,
  macAndGateway,
  publicIpAndProvider,
  ImindanaoStoreCounts,
  IzabbixCircuitDetails,
  IproviderCircuitsTodayCounts,
  Iticket,
  ImacAndPublicIp,
  rowsLog,
  // rowsCircuitLog,
  rowsCircuitsLog,
  IcliqqByStore,
  rowsProviderInventory,
  IassetsStoreInfo,
  IdevicesNetbox,
  DownCircuits,
} from "./types";
import { useQuasar } from "quasar";

const $q = useQuasar();
// const API_BASE_URL = process.env.VUE_APP_WORKCONNECT_API_URL;

const api = axios.create({
  baseURL: "",
  timeout: 0,
});

export const extractCSV = async () => {
  const response = await axios.get("/download-csv", {
    responseType: "blob",
  });

  return response;
};

export const extractStoreDataCSV = async () => {
  const response = await axios.get("/getStoreDataCsv", {
    responseType: "blob",
  });
  return response;
};

export const prometheusData = async (): Promise<prometheusDataReturn> => {
  const { data } = await axios.get(`/api/nms/prometheusData`);

  return data;
};

export const nmsData = async (): Promise<nmsDataReturn> => {
  const { data } = await axios.get(`/api/nms/countAllNms`);

  return data;
};
export const getAllStoreData = async () => {
  const { data } = await axios.get(`/api/nms/AllStores`, {
    params: {
      clientIp: getCLientIp(),
    },
  });
  return data;
};
export const getMindanaStores = async () => {
  const { data } = await axios.get(`/api/nms/mindanaoStores`);

  return data;
};
export const getAllStoreCounts = async (): Promise<IcountAllStore> => {
  const { data } = await axios.get(`/api/nms/getAllStoreCounts`);

  return data;
};
export const getMidanaoStoresCount =
  async (): Promise<ImindanaoStoreCounts> => {
    const { data } = await axios.get(`/api/nms/countMindanaoStores`, {
      params: {
        clientIp: await getCLientIp(),
      },
    });

    return data;
  };
export const getProviderCircuitsToday =
  async (): Promise<IproviderCircuitsTodayCounts> => {
    const { data } = await axios.get("/api/nms/countProviderCircuitsToday");

    return data;
  };

export const getStoreProfile = async (
  siteId: string
): Promise<IstoreProfile> => {
  const { data } = await axios.get(`/api/atis/site`, {
    params: {
      site_id: siteId,
    },
  });

  return data;
};
export const getStoreProfileAdditional = async (
  siteId: string
): Promise<IstoreProfile> => {
  const { data } = await axios.get(`/api/nms/getStoreProfile`, {
    params: {
      siteId: siteId,
      clientIp: await getCLientIp(),
    },
  });

  return data;
};

export const getStoreDetails = async (siteId: string) => {
  const { data } = await axios.get(`/api/nms/getDetailsSite/${siteId}`);
  // console.log(siteId, data);

  return data;
};
export const getDetailsList = async (store: DetailsList) => {
  const { data } = await axios.get(`/api/nms/getListing`, {
    params: {
      store: store,
    },
  });

  return data;
};

export const getMacAndGateway = async (
  storeId: string
): Promise<macAndGateway> => {
  const { data } = await axios.get("/api/nms/getMacAndGtwIp", {
    params: {
      storeId: storeId,
      clientIp: await getCLientIp(),
    },
  });

  return data;
};

export const getMacAndPublicIp = async (
  storeId: string
): Promise<ImacAndPublicIp> => {
  const { data } = await axios.get("/api/nms/getMacAndPublicIp", {
    params: {
      storeId: storeId,
      clientIp: await getCLientIp(),
    },
  });

  return data;
};

export const getPingStore = async (
  storeId: string
): Promise<{ provider: string; pingMsg: string }> => {
  const { data } = await axios.get("/api/nms/getPingStore", {
    params: {
      storeId: storeId,
    },
  });

  return data;
};
export const getLoopbackPing = async (storeId: string): Promise<string[]> => {
  const { data } = await axios.get("/api/nms/getLoopbacks", {
    params: {
      storeId: storeId,
    },
  });

  return data;
};
export const getTraceRoute = async (
  storeId: string,
  type: string
): Promise<string> => {
  const { data } = await axios.get("/api/nms/getTraceRoute", {
    params: {
      storeId: storeId,
      type: type,
    },
  });

  return data;
};

export const getPublicIp = async (
  storeId: string
): Promise<publicIpAndProvider> => {
  const { data } = await axios.get("/api/nms/getPublicIp", {
    params: {
      storeId: storeId,
      clientIp: await getCLientIp(),
    },
  });

  return data;
};

export const provisionGTv3 = async (
  storeId: string,
  ipAdd: string,
  routerType: string
) => {
  const { data } = await axios.post("/api/playbook/provisionGTv3", null, {
    params: {
      storeId: storeId,
      ansibleHost: ipAdd,
      routerType: routerType,
    },
  });

  return data;
};

export const getZabbixCircuitDetails = async (
  storeId: string,
  fromDate: string,
  toDate: string
): Promise<IzabbixCircuitDetails[]> => {
  const { data } = await axios.get("/api/zabbix/circuit_details", {
    params: {
      storeId: storeId,
      fromDate: fromDate,
      toDate: toDate,
    },
  });

  return data;
};
export const getZabbixCircuitReport = async (
  storeId: string,
  fromDate: string,
  toDate: string
) => {
  try {
    const { data } = await axios.get(`/api/zabbix/get_zabbix_report`, {
      params: {
        storeId: storeId,
        fromDate: fromDate,
        toDate: toDate,
      },
    });

    return data;
  } catch (error) {
    console.error("Axios error:", error);
  }
};
export const getCliqqSummaryByStoreId = async (
  start_date: string,
  end_date: string,
  storeId: string
): Promise<IcliqqByStore[]> => {
  const { data } = await axios.get(`/api/cliqq/getCliqqSummaryByStoreId`, {
    params: {
      start_date: start_date,
      end_date: end_date,
      storeId: storeId,
    },
  });

  return data;
};

export const cliqq_wifi_report = async (
  start_date: string,
  end_date: string
) => {
  try {
    const { data } = await axios.get(`/api/cliqq/get_num_users_and_duration`, {
      params: {
        start_date: start_date,
        end_date: end_date,
      },
    });

    return data;
  } catch (error) {
    console.error("Axios error:", error);
  }
};

export const getTickets = async (storeId: string): Promise<Iticket[]> => {
  const { data } = await axios.get("/api/rt/sites/ticket", {
    params: {
      site_id: storeId,
      clientIp: await getCLientIp(),
    },
  });

  return data;
};

export const getCircuitReport = async () => {
  const { data } = await axios.get(`/api/nms/getCircuitReport`);

  return data;
};

// export const getZabbixDownStores = async () => {
//   const { data } = await axios.get(`/api/nms/getZabbixDownStores`);

//   return data;
// };

export const getWorkconnectLogs = async (): Promise<rowsLog[]> => {
  const { data } = await axios.get("/api/elastic/findAll");
  return data;
};
export const getWorkconnectLogsPeriod = async (
  from: string,
  to: string
): Promise<rowsLog[]> => {
  const { data } = await axios.get("/api/elastic/getElasticLogByTimePeriod", {
    params: {
      fromDate: from,
      toDate: to,
    },
  });
  return data;
};
export const getElasticLogByStoreId = async (
  storeId: string
): Promise<rowsLog[]> => {
  const { data } = await axios.get("/api/elastic/getElasticLogByStoreId", {
    params: {
      storeId: storeId,
    },
  });
  return data;
};

export const getCircuitLogs = async (): Promise<rowsCircuitsLog[]> => {
  const { data } = await axios.get("/api/elastic/findAllCircuitsLogs");
  return data;
};

export const getCircuitLogsBySiteId = async (
  siteId: string
): Promise<rowsCircuitsLog[]> => {
  const { data } = await axios.get("/api/elastic/findAllCircuitsLogsBySiteId", {
    params: { storeId: siteId },
  });
  return data;
};

export const getCircuitLogsProviderBySiteId = async (
  siteId: string
): Promise<rowsCircuitsLog[]> => {
  const { data } = await axios.get(
    "/api/elastic/findAllCircuitsLogsProviderBySiteId",
    {
      params: { storeId: siteId },
    }
  );
  return data;
};

export const getCircuitLogsMacBySiteId = async (
  siteId: string
): Promise<rowsCircuitsLog[]> => {
  const { data } = await axios.get(
    "/api/elastic/findAllCircuitsLogsMacBySiteId",
    {
      params: { storeId: siteId },
    }
  );
  return data;
};

export const getCircuitLogsImsiBySiteId = async (
  siteId: string
): Promise<rowsCircuitsLog[]> => {
  const { data } = await axios.get(
    "/api/elastic/findAllCircuitsLogsImsiBySiteId",
    {
      params: { storeId: siteId },
    }
  );
  return data;
};

export const getCircuitLogsProvider = async (): Promise<rowsCircuitsLog[]> => {
  const { data } = await axios.get("/api/elastic/findAllCircuitsLogsProvider");
  return data;
};

export const getCircuitLogsMac = async (): Promise<rowsCircuitsLog[]> => {
  const { data } = await axios.get("/api/elastic/findAllCircuitsLogsMac");
  return data;
};

export const getCircuitLogsImsi = async (): Promise<rowsCircuitsLog[]> => {
  const { data } = await axios.get("/api/elastic/findAllCircuitsLogsImsi");
  return data;  
};

export const getAtisInventory = async (
  provider: string
): Promise<rowsProviderInventory[]> => {
  const { data } = await axios.get("/api/nms/getProviderInventory", {
    params: { provider: provider },
  });
  return data;
};

export const insertWorkconnectLog = async (
  actions: string,
  status?: number,
  service?: string,
  payLoad?: string
) => {
  const executedFrom = process.env.VUE_APP_ACTION;
  try {
    console.log(actions, status, service, payLoad);

    const sanitizedStatus = status ? status : 200;
    const sanitizedService = service ? service : "none";
    const sanitizedPayload = payLoad ? payLoad : "none";
    const ip = await getCLientIp();
    console.log(ip);

    const { data } = await axios.post("/api/elastic/elkLog", null, {
      params: {
        action: executedFrom + " " + actions,
        status: sanitizedStatus,
        service: sanitizedService, // endpoint
        payload: sanitizedPayload, // akoang gi send
        clientIp: ip,
      },
    });

    return data;
  } catch (error) {
    console.error("Error inserting work connect log:", error);
    throw error;
  }
};

export const getAtisAssets = async (
  storeId: string
): Promise<IassetsStoreInfo[]> => {
  const { data } = await axios.get("/api/atis/assets", {
    params: { site_id: storeId },
  });
  return data;
};
export const getDevicesNetbox = async (
  storeId: string
): Promise<IdevicesNetbox> => {
  const { data } = await axios.post("/api/netbox/find/site/device/modem", {
    site_name: storeId,
  });
  return data;
};

export const getCLientIp = async (): Promise<string> => {
  const response = await api.get("https://api.ipify.org");
  console.log("Client ip " + response.data);

  return response.data;
};
export const getSNMPSerial = async (storeId: string): Promise<string> => {
  const { data } = await axios.get("/api/autodiscover/getSNMP", {
    params: {
      storeId: storeId,
      clientIp: await getCLientIp(),
    },
  });

  return data;
};

export const getDownPrimary = async (): Promise<DownCircuits[]> => {
  const { data } = await axios.get("/api/nms/getDownCircuitsPrimary");

  return data;
};
export const getDownBackup = async (): Promise<DownCircuits[]> => {
  const { data } = await axios.get("/api/nms/getDownCircuitsBackup");

  return data;
};

export const getCircuitsLogMacByTimePeriod = async (
  from: string,
  to: string
): Promise<rowsCircuitsLog[]> => {
  const { data } = await axios.get("/api/elastic/getCircuitsLogMacByTimePeriod", {
    params: {
      fromDate: from,
      toDate: to,
    },
  });
  return data;
};


export const getCircuitsLogProvByTimePeriod = async (
  from: string,
  to: string
): Promise<rowsCircuitsLog[]> => {
  const { data } = await axios.get("/api/elastic/getCircuitsLogProvByTimePeriod", {
    params: {
      fromDate: from,
      toDate: to,
    },
  });
  return data;
};


export const getCircuitsLogImsiByTimePeriod = async (
  from: string,
  to: string
): Promise<rowsCircuitsLog[]> => {
  const { data } = await axios.get("/api/elastic/getCircuitsLogImsiByTimePeriod", {
    params: {
      fromDate: from,
      toDate: to,
    },
  });
  return data;
};
