import { ExtendRefOptions } from "@vueuse/core";

export interface prometheusDataReturn {
  totalStores: number;
  temporarilyClosed: number;
  totalMikrotikStores: number;
  totalRuijiStores: number;

  totalDownStores: number;
  // totalDownMikrotik: number;
  // totalDownRuiji: number;
  zabbixDownStores: number;
  // problematicStoresLess95_7d: number;
  // problematicBackup0_7d: number;
  // problematicBackupLess95_7d: number;
  // problematicBackupLess95_24hrs: number;
  // problematicStoresLess95_24hrs: number;
  // problematicStores0_7d: number;
  // problematicPrimary0_7d: number;
  // problematicPrimaryLess95_7d: number;
  // problematicPrimaryLess95_24hrs: number;
}

export interface nmsDataReturn {
  // problematicSingleCircuit: number;
  // backupWired: number;
  // primaryWireless: number;
  // problematicWirelessOnly: number;
  // problematicPrimaryNoProvider: number;
  // problematicBackupNoProvider: number;
  // primaryCircuitNoInternet: number;
  // backupCircuitNoInternet: number;
  // backup100_7d: number;
  // primary100_7d: number;
  // dual_circuit_7d: number;
  // primary_only_7d: number;
  // backup_only_7d: number;
  // store100_7d: number;
  // store_healthy_7d: number;
  zabbixDownStores: number;
}
export interface IcountAllStore extends prometheusDataReturn, nmsDataReturn {}

export interface ImindanaoStoreCounts {
  allMindanaoStores: number;
  downMindanaoStores: number;
  mindanaoDualCircuit: number;
  mindanaoPrimaryOnly: number;
  mindanaoBackupOnly: number;
  mindanaoDownStore7D: number;
  mindanaoProblematic7D: number;
  mindanaoHealthyStore7D: number;
  mindanaoExcellent7D: number;
}

export interface IproviderCircuitsTodayCounts {
  providerCircuitsToday: number;
  dualCircuit7D: number;
  primaryOnly7D: number;
  backupOnly7D: number;
  thirdOnly7D: number;
  dualCircuit24H: number;
  primaryOnly24H: number;
  backupOnly24H: number;
  thirdOnly24H: number;
  down7d: number;
  problematic7d: number;
  healthy7d: number;
  excellent7d: number;
  down24h: number;
  problematic24h: number;
  healthy24h: number;
  excellent24h: number;
  timeStamp: string;
}

export interface countTypes {
  title: string;
  value: string | number;
  bgColor: "bg-info" | "bg-warning" | "bg-negative" | "bg-accent";

  bigSize?: boolean;
  icon_position?: boolean;

  tableType?: DetailsList;
}
export type DetailsList =
  | "down_store"
  | "down_mikrotik"
  | "down_ruijie"
  | "problematic0_7d"
  | "problematic95_7d"
  | "problematic95_24h"
  | "wireless_only"
  | "single_circuit"
  | "primary0_7d"
  | "primary100_7d"
  | "primary95_7d"
  | "primary95_24h"
  | "backup0_7d"
  | "backup100_7d"
  | "backup95_7d"
  | "backup95_24h"
  | "primary_no_internet"
  | "primary_no_provider"
  | "backup_no_internet"
  | "backup_no_provider"
  | "primary_wireless"
  | "backup_wired"
  | "dual_circuit_7d"
  | "primary_only_7d"
  | "backup_only_7d"
  | "store100_7d"
  | "store_healthy_7d"
  | "mindanao_stores"
  | "mindanao_down_stores"
  | "mindanao_dual_circuit_7d"
  | "mindanao_primary_only_7d"
  | "mindanao_backup_only_7d"
  | "provider_circuits_today"
  | "pct_dual_circuit_7d"
  | "pct_primary_only_7d"
  | "pct_backup_only_7d"
  | "pct_dual_circuit_24h"
  | "pct_primary_only_24h"
  | "pct_backup_only_24h"
  | "pct_down_7d"
  | "pct_problematic_7d"
  | "pct_healthy_7d"
  | "pct_excellent_7d"
  | "pct_down_24h"
  | "pct_problematic_24h"
  | "pct_healthy_24h"
  | "pct_excellent_24h"
  | "mindanao_down_7d"
  | "mindanao_problematic_7d"
  | "mindanao_healthy_7d"
  | "mindanao_excellent_7d"
  | "third_only_7d"
  | "third_only_24h";

export interface IdetailsListData {
  store_description: string;
  loopback_1: number;
  loopback_2: number;
  loopback_0: number;
  loopback_3: number;
  loopback_3_24h: number;
  loopback_1_24h: number;
  loopback_2_24h: number;
  loopback_0_24h: number;
  primary_circuit_status: string;
  provider_primary: string;
  site_id: string;
  provider_backup: string;
  backup_circuit_status: string;
  mac_primary: string;
  mac_backup: string;
  public_ip_primary: string;
  public_ip_backup: string;
  imsi_primary: string;
  imsi_backup: string;
  latitude: number;
  longitude: number;
  city: string;
  province: string;
  region: string;
  zabbix_down_duration: string;
  router: string;
}
export interface IcircuitInfo {
  mac_primary: string;
  mac_backup: string;
  mac_third: string;
  gtw_primary: string;
  gtw_backup: string;
  gtw_third: string;
  public_ip_primary: string;
  public_ip_backup: string;
  public_ip_third: string;
  provider_primary: string;
  provider_backup: string;
  provider_third: string;
  backup_third: string;
}
export interface IProviderCircuit {
  router: string;
  loopback_1: number;
  loopback_2: number;
  loopback_0: number;
  loopback_3: number;
  loopback_1_24h: number;
  loopback_2_24h: number;
  loopback_3_24h: number;
  loopback_0_24h: number;
  zabbix_down_duration: string;
  serial_number: string;
}

export interface IstoreProfile extends IdetailsListData, IcircuitInfo {
  id: string;
  site_id: string;
  name: string;
  island_group: string;
  address: string;
  contact_person: string;
  contact_nos: string;
  tenant_name: string;
  zipcode: string;
  date_created: string;
  date_last_updated: string;
  region: string;
  status: string;
  links_up: string;
  latitude: number;
  longitude: number;
  circuits: unknown;
  lo0: string;
  lo1: string;
  lo2: string;
  lo3: string;
  serial_number: string;
}

export interface macAndGateway {
  mac_primary: string;
  mac_backup: string;
  gtw_primary: string;
  gtw_backup: string;
}

export interface publicIpAndProvider {
  store_provider?: string;
  public_ip_primary: string;
  public_ip_backup: string;
  provider_primary: string;
  provider_backup: string;
}
export interface ImacAndPublicIp extends publicIpAndProvider, macAndGateway {}
export interface zabbixStore {
  vip_lastchange: string;
  site_id: string;
  vip: number;
  vip_events: zabbixEvents[];
  vip_ip: string;
}

export interface zabbixPrimary {
  primary_lastchange: string;
  site_id: string;
  primary: number;
  primary_events: zabbixEvents[];
  primary_ip: string;
}
export interface zabbixBackup {
  backup_lastchange: string;
  site_id: string;
  backup: number;
  backup_events: zabbixEvents[];
  backup_ip: string;
}

export interface zabbixEvents {
  eventid: number;
  start: string;
  end: string;
}

export interface IzabbixCircuitDetails
  extends zabbixBackup,
    zabbixPrimary,
    zabbixStore {}

export interface Iticket {
  Status: string;
  Owner: string;
  SiteID: string;
  link: string;
  id: string;
  Creator: string;
  LastUpdated: string;
  Queue: string;
  Subject: string;
  Created: string;
}

export interface IcircuitReport {
  id: string;
  provider: string;
  active: number;
  notFoundWMac: number;
  notFoundWoutMac: number;
  notInList: number;
  atis: number;
}
export interface rowsLog {
  payload: string;
  service: string;
  action: string;
  id: string;
  user: string;
  roleGroup: string[];
  tenant: string;
  timestampMilliSec: number;
  status: string;
  clientIp: string;
}

// export interface rowsCircuitLog {
//   id: string;
//   timestamp: string;
//   router: string;
//   siteID: string;
//   mac1: string;
//   mac1Status: string;
//   mac2: string;
//   mac2Status: string;
//   IMSI: string;
//   IMSIStatus: string;
//   provider1: string;
//   provider1Status: string;
//   provider2: string;
//   provider2Status: string;
//   providerCellular: string;
//   providerCellularStatus: string;
//   publicIp1: string;
//   publicIp2: string;
//   publicIpCellular: string;

// }

export interface rowsCircuitsLog {
  id: string;
  timestamp: string;
  router: string;
  siteID: string;
  mac: string;
  macStatus: string;
  imsi: string;
  recentDATE: string;
  RecentPrimaryprovider: string;
  RecentBackupProvider: string;
  PreviousPrimaryProvider: string;
  PreviousBackupProvider: string;
  publicIp: string;
  port: string;
  previousDATE: string;
  previous: string;

}

export interface rowsProviderInventory {
  id: string;
  site_id: string;
  provider: string;
  atis: boolean;
  autodiscover: boolean;
  acc_no: string;
  name: string;
  last_update: string;
  status: string;
}

export interface Icliqq {
  site_id: string;
  average_time_s: number;
  session_count: number;
}

export interface IcliqqByStore {
  terminateCause: string;
  callingStationId: string;
  stopTime: string;
  sessionTime: number;
  inputoctets: number;
  outputoctets: number;
  startTime: string;
}

export interface IassetsStoreInfo {
  status: string;
  name: string;
  serial_number: string;
  site_id: string;
  condition: string;
  property_code: string;
  equipment_code: string;
}
export interface IdevicesNetbox {
  data: IdevicesNetboxData[];
}
export interface IdevicesNetboxData {
  name: string;
  status: { value: string; label: string };
  serial: string;
  device_role: {
    name: string;
  };
  device_type: {
    manufacturer: {
      name: string;
    };
    model: string;
  };
}
export interface DownCircuits {
  site_id: string;
  lastchange: number;
  circuitType: string;
  provider: string;
}
