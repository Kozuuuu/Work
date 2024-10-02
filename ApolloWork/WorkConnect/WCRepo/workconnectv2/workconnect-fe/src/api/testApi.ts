import axios from "axios";

// const API_BASE_URL = 'http://localhost:8080';
const API_BASE_URL = "http://172.91.10.158:7500";

const api = axios.create({
  baseURL: API_BASE_URL,
});

export const getAllStores = async () => {
  const response = await api.get("api/atis/site/v2/list?", {
    params: {
      site_id: "",
      siteName: "",
      tenant: "",
      no_links_up: "",
      circuit_provider: "",
      siteStatus: "",
      region: "",
      group: "",
    },
  });
  return response.data;
};

export const getDetailsofStore = async (siteId: string) => {
  const response = await api.get("api/atis/site/v2/list?", {
    params: {
      site_id: siteId,
      siteName: "",
      tenant: "",
      no_links_up: "",
      circuit_provider: "",
      siteStatus: "",
      region: "",
      group: "",
    },
  });
  return response.data;
};

export const getPSC = async () => {
  const response = await api.get("api/atis/site/v2/list?", {
    params: {
      site_id: "",
      siteName: "",
      tenant: "Philippine Seven Corporation",
      no_links_up: "down",
      circuit_provider: "",
      siteStatus: "",
      region: "",
      group: "",
    },
  });
  return response.data;
};

export const getHistoryPrometheusApi = async (
  site_id: string,
  hours: number,
  date: string
) => {
  const response = await api.get("/api/atis/site/prometheus/circuits", {
    params: { site_id: site_id, hours_interval: hours, str_end_date: date },
  });
  return response.data;
};

export const getTrafficInPrometheus = async (
  site_id: string,
  hours: number,
  interval: number,
  date: string
) => {
  const response = await api.get("/api/prometheus/site/traffic_in", {
    params: {
      site_id: site_id,
      hours: hours,
      interval_in_min: interval,
      str_end_date: date,
    },
  });

  return response.data;
};

export const getTrafficOutPrometheus = async (
  site_id: string,
  hours: number,
  interval: number,
  date: string
) => {
  const response = await api.get("/api/prometheus/site/traffic_out", {
    params: {
      site_id: site_id,
      hours: hours,
      interval_in_min: interval,
      str_end_date: date,
    },
  });
  return response.data;
};

export const getHistoryZabbix = async (site_id: string) => {
  const response = await api.get("/api/zabbix/circuit_details", {
    params: { site_id: site_id },
  });
  return response.data;
};
export const getLoopbackStatus = async () => {
  console.log("hello");
};

export const getDetailsofSite = async () => {
  console.log("hello");
};
