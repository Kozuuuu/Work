package com.tracker_app.tracker.Controller;

import com.tracker_app.tracker.DataSource_NMS.Entity.atis_inventory;
import com.tracker_app.tracker.DataSource_NMS.Entity.provider_circuit_report;
import com.tracker_app.tracker.DataSource_NMS.Helper.util;
import com.tracker_app.tracker.DataSource_NMS.Repo.atis_inventory_repo;
import com.tracker_app.tracker.DataSource_NMS.Repo.automated_imsi_repo;
import com.tracker_app.tracker.DataSource_NMS.Repo.circuit_repo;
import com.tracker_app.tracker.DataSource_NMS.Repo.provider_circuits_mindanao_repo;
import com.tracker_app.tracker.DataSource_NMS.Repo.provider_circuits_repo;
import com.tracker_app.tracker.DataSource_NMS.Repo.provider_circuits_report_repo;
import com.tracker_app.tracker.DataSource_NMS.Repo.provider_circuits_today_repo;
import com.tracker_app.tracker.DataSource_NMS.Repo.store_count_repo;
import com.tracker_app.tracker.DataSource_NMS.Repo.store_count_today_repo;
import com.tracker_app.tracker.DataSource_NMS.Repo.store_data_repo;
import com.tracker_app.tracker.DataSource_NMS.Service.circuit_service;
import com.tracker_app.tracker.DataSource_NMS.Service.mac_retrieve_service;
import com.tracker_app.tracker.DataSource_NMS.Service.store_count_down_service;
import com.tracker_app.tracker.DataSource_NMS.Service.store_count_service;
import com.tracker_app.tracker.DataSource_Zabbix.Repo.hosts_repo;
import com.tracker_app.tracker.DataSource_elasticsearch.service.ElasticLogService;
import com.tracker_app.tracker.Helper.AuthService;
import com.tracker_app.tracker.Helper.zabbix_helper;
import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.configurationprocessor.json.JSONException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.tracker_app.tracker.DataSource_NMS.Service.ProviderService;
import com.tracker_app.tracker.DataSource_NMS.Entity.Provider;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping(path = "/api/nms/")
public class nms_controller {

  @Autowired
  private circuit_service circuitService;

  @Autowired
  private circuit_repo circuit_repo;

  @Autowired
  private store_data_repo store_data_repo;

  @Autowired
  private SimpMessagingTemplate messagingTemplate;

  @Autowired
  private provider_circuits_repo provider_circuits_repo;

  @Autowired
  private automated_imsi_repo automated_imsi_repo;

  @Autowired
  private mac_retrieve_service mac_retrieve_service;

  @Autowired
  private provider_circuits_today_repo provider_circuits_today_repo;

  @Autowired
  private provider_circuits_mindanao_repo providerCircuitsMindanaoRepo;

  @Autowired
  private provider_circuits_report_repo provider_circuits_report_repo;

  @Autowired
  private atis_inventory_repo atis_inventory_repo;

  @Autowired
  private util util;

  @Autowired
  private ElasticLogService elasticLogService;

  @Autowired
  private AuthService authService;

  @Autowired
  private store_count_today_repo store_count_today_repo;

  @Autowired
  private store_count_down_service store_count_down_service;

  @Autowired
  private zabbix_helper zabbix_helper;

  @Autowired
  private hosts_repo hosts_repo;

  @Autowired
  private ProviderService ProviderService;

  // @GetMapping("/countAllNms")
  // public ResponseEntity<Map<String, Object>> countAllNms() {
  // Map<String, Object> result = circuitService.countAllNms();
  // return new ResponseEntity<>(result, HttpStatus.OK);
  // }

  // @GetMapping("/prometheusData")
  // public ResponseEntity<Map<String, Object>> prometheusCount() {
  // Map<String, Object> result = circuitService.countPrometheusData();
  // return new ResponseEntity<>(result, HttpStatus.OK);
  // }

  // @Cacheable("getAllStoreCounts")
  @GetMapping("getAllStoreCounts")
  public ResponseEntity<Map<String, Object>> getAllStoreCounts(
    // @RequestHeader(value = "Authorization", required = false) String auth
  ) {
    // elasticLogService.saveWorkConnectLog(
    // auth,
    // "Api call - backend",
    // "200",
    // "api/nms/getAllStoreCounts",
    // "none"
    // );
    Map<String, Object> result = new HashMap<>();
    // Map<String, Object> nmsCount = circuitService.countAllNms();
    Map<String, Object> promCount = circuitService.countPrometheusData();

    // result.putAll(nmsCount);
    result.putAll(promCount);

    messagingTemplate.convertAndSend("/topic/storeCounts", result);
    // result.put("listing", storeList);
    return new ResponseEntity<>(result, HttpStatus.OK);
  }

  // @Cacheable("allStoreData")
  // @GetMapping("AllStores")
  // public ResponseEntity<List<Map<String, Object>>> getAllStoreData(
  //   @RequestHeader(value = "Authorization", required = false) String auth,
  //   @RequestParam String clientIp
  // ) {
  //   elasticLogService.saveWorkConnectLog(
  //     auth,
  //     "Api call - backend",
  //     "",
  //     "api/nms/AllStores",
  //     "none",
  //     clientIp
  //   );
  //   return new ResponseEntity<>(
  //     store_data_repo.getAllStoreData(),
  //     HttpStatus.OK
  //   );
  // }

  @GetMapping("countMindanaoStores")
  public ResponseEntity<Map<String, Object>> getMindanaoStores(
    @RequestHeader(value = "Authorization", required = false) String auth,
    @RequestParam(value = "clientIp", required = false) String clientIp
  ) {
    elasticLogService.saveWorkConnectLog(
      auth,
      "Api call - backend",
      "",
      "api/nms/countMindanaoStores",
      "none",
      clientIp
    );
    Map<String, Object> mindanao = circuitService.countMindanao();
    return new ResponseEntity<>(mindanao, HttpStatus.OK);
  }

  @GetMapping("countProviderCircuitsToday")
  public ResponseEntity<Map<String, Object>> getCountProviderCircuitsToday(
    // @RequestHeader(value = "Authorization", required = false) String auth
  ) {
    // elasticLogService.saveWorkConnectLog(
    // auth,
    // "Api call - backend",
    // "",
    // "api/nms/countProviderCircuitsToday",
    // "none"
    // );
    Map<String, Object> mindanao = circuitService.countProviderCircuitsToday();
    return new ResponseEntity<>(mindanao, HttpStatus.OK);
  }

  @GetMapping("/getStoreProfile")
  public ResponseEntity<Map<String, Object>> getDetailsOfSite(
    @RequestHeader(value = "Authorization", required = false) String auth,
    @RequestParam String siteId,
    @RequestParam String clientIp
  ) {
    elasticLogService.saveWorkConnectLog(
      auth,
      "Api call - backend",
      HttpStatus.OK.toString(),
      "api/nms/getStoreProfile",
      siteId,
      clientIp
    );
    Map<String, Object> siteDetails = store_data_repo.findDetailsBySiteId(
      siteId
    );
    Map<String, Object> siteMacDetails = provider_circuits_repo.findDetailsProviderCircuitBySiteId(
      siteId
    );
    Map<String, Object> siteImsi = automated_imsi_repo.findImsiBySiteId(siteId);
    Map<String, Object> mergedDetails = new HashMap<>();
    String lo0 = circuitService.getLoopbackIp(siteId, 0);
    String lo1 = circuitService.getLoopbackIp(siteId, 1);
    String lo2 = circuitService.getLoopbackIp(siteId, 2);
    String lo3 = circuitService.getLoopbackIp(siteId, 3);

    mergedDetails.putAll(siteDetails);
    mergedDetails.putAll(siteMacDetails);
    if (siteImsi != null) {
      mergedDetails.putAll(siteImsi);
    }
    mergedDetails.put("lo0", lo0);
    mergedDetails.put("lo1", lo1);
    mergedDetails.put("lo2", lo2);
    mergedDetails.put("lo3", lo3);
    return new ResponseEntity<>(mergedDetails, HttpStatus.OK);
  }

  @GetMapping("getCircuitReport")
  public ResponseEntity<List<provider_circuit_report>> getCircuitReport() {
    List<provider_circuit_report> provider_report = provider_circuits_report_repo.getLatestProviderCircuitsReports();
    return new ResponseEntity<>(provider_report, HttpStatus.OK);
  }

  // @GetMapping("getZabbixDownStores")
  // public Integer getZabbixDownStores() {
  //   Integer zabbixDownStores = store_count_today_repo.getZabbixDownStores();
  //   return zabbixDownStores;
  // }

  @GetMapping("getListing")
  public ResponseEntity<List<Map<String, Object>>> getStoreLists(
    // @RequestHeader(value = "Authorization", required = false) String auth,
    @RequestParam String store
  ) {
    Double threshold = circuitService.thresholdValue;
    List<String> siteList = new CopyOnWriteArrayList<>();

    switch (store) {
      case "down_store":
        siteList = circuitService.getAllDownStoresSiteId();
        break;
      case "down_mikrotik":
        siteList = circuitService.getMikroktikDownStoresSiteId();
        break;
      case "down_ruijie":
        siteList = circuitService.getRuijieDownStoresSiteId();
        break;
      case "problematic0_7d":
        return getStoreListResponse(
          store_data_repo.getProblematicStore0up7Days()
        );
      case "problematic95_7d":
        return getStoreListResponse(
          store_data_repo.getProblematicStore95up7Days(threshold)
        );
      case "problematic95_24h":
        return getStoreListResponse(
          store_data_repo.getProblematicStore95up24h(threshold)
        );
      // case "wireless_only":
      // return getStoreListResponse(store_data_repo.getWirelessOnlyTableList());
      // case "single_circuit":
      // return getStoreListResponse(
      // store_data_repo.getSingleCircuitTableList()
      // );
      // case "primary0_7d":
      // return getStoreListResponse(
      // store_data_repo.getPrimaryCircuit0up7Days()
      // );
      // case "primary95_7d":
      // return getStoreListResponse(
      // store_data_repo.getPrimaryCircuit95up7Days(threshold)
      // );
      // case "primary100_7d":
      // return getStoreListResponse(
      // store_data_repo.getPrimaryCircuit100up7Days()
      // );
      // case "primary95_24h":
      // return getStoreListResponse(
      // store_data_repo.getPrimaryCircuit95up24h(threshold)
      // );
      // case "primary_no_internet":
      // return getStoreListResponse(
      // store_data_repo.getPrimaryCircuitNoInternetTableList()
      // );
      // case "primary_no_provider":
      // return getStoreListResponse(
      // store_data_repo.getPrimaryCircuitNoProviderTableList()
      // );
      // case "primary_wireless":
      // siteList = circuit_repo.getPrimaryWirelessSiteIds();
      // break;
      case "backup0_7d":
        return getStoreListResponse(store_data_repo.getBackupCircuit0up7Days());
      case "backup95_7d":
        return getStoreListResponse(
          store_data_repo.getBackupCircuit95up7Days(threshold)
        );
      case "backup100_7d":
        return getStoreListResponse(
          store_data_repo.getBackupCircuit100up7Days()
        );
      case "backup95_24h":
        return getStoreListResponse(
          store_data_repo.getBackupCircuit95up24h(threshold)
        );
      case "backup_no_internet":
        return getStoreListResponse(
          store_data_repo.getBackupCircuitNoInternetTableList()
        );
      case "backup_no_provider":
        return getStoreListResponse(
          store_data_repo.getBackupCircuitNoProviderTableList()
        );
      case "backup_wired":
        siteList = circuit_repo.getBackupWiredSiteIds();
        break;
      case "dual_circuit_7d":
        return getStoreListResponse(store_data_repo.getDualCircuit7D());
      case "primary_only_7d":
        return getStoreListResponse(store_data_repo.getPrimaryOnly7D());
      case "backup_only_7d":
        return getStoreListResponse(store_data_repo.getBackupOnly7D());
      case "store_healthy_7d":
        return getStoreListResponse(store_data_repo.getHealhyLoopback0_7D());
      case "store100_7d":
        return getStoreListResponse(store_data_repo.getLoopback0_100uptime7D());
      case "mindanao_stores":
        return getStoreListResponse(
          providerCircuitsMindanaoRepo.getMindanaoList()
        );
      case "mindanao_down_stores":
        return getStoreListResponse(
          providerCircuitsMindanaoRepo.getSpecificMindanaoList(
            circuitService.getAllDownStoresSiteId()
          )
        );
      case "mindanao_dual_circuit_7d":
        return getStoreListResponse(
          providerCircuitsMindanaoRepo.getMindanaoDualCircuit()
        );
      case "mindanao_primary_only_7d":
        return getStoreListResponse(
          providerCircuitsMindanaoRepo.getMindanaoPrimaryOnly()
        );
      case "mindanao_backup_only_7d":
        return getStoreListResponse(
          providerCircuitsMindanaoRepo.getMindanaoBackupOnly()
        );
      case "mindanao_down_7d":
        return getStoreListResponse(
          providerCircuitsMindanaoRepo.getDownStore_7D()
        );
      case "mindanao_problematic_7d":
        return getStoreListResponse(
          providerCircuitsMindanaoRepo.getProblematicStore_7D()
        );
      case "mindanao_healthy_7d":
        return getStoreListResponse(
          providerCircuitsMindanaoRepo.getHealhyStore7D()
        );
      case "mindanao_excellent_7d":
        return getStoreListResponse(
          providerCircuitsMindanaoRepo.getStore100uptime7D()
        );
      case "provider_circuits_today":
        return getStoreListResponse(
          provider_circuits_today_repo.getProviderCircuitsToday()
        );
      case "pct_dual_circuit_7d":
        return getStoreListResponse(
          provider_circuits_today_repo.getDualCircuit7D()
        );
      case "pct_primary_only_7d":
        return getStoreListResponse(
          provider_circuits_today_repo.getPrimaryOnly7D()
        );
      case "pct_backup_only_7d":
        return getStoreListResponse(
          provider_circuits_today_repo.getBackupOnly7D()
        );
      case "pct_dual_circuit_24h":
        return getStoreListResponse(
          provider_circuits_today_repo.getDualCircuit24H()
        );
      case "pct_primary_only_24h":
        return getStoreListResponse(
          provider_circuits_today_repo.getPrimaryOnly24H()
        );
      case "pct_backup_only_24h":
        return getStoreListResponse(
          provider_circuits_today_repo.getBackupOnly24H()
        );
      case "pct_down_7d":
        return getStoreListResponse(
          provider_circuits_today_repo.getDownStore_7D()
        );
      case "pct_problematic_7d":
        return getStoreListResponse(
          provider_circuits_today_repo.getProblematicStore_7D()
        );
      case "pct_healthy_7d":
        return getStoreListResponse(
          provider_circuits_today_repo.getHealhyStore7D()
        );
      case "pct_excellent_7d":
        return getStoreListResponse(
          provider_circuits_today_repo.getStore100uptime7D()
        );
      case "pct_down_24h":
        return getStoreListResponse(
          provider_circuits_today_repo.getDownStore_24H()
        );
      case "pct_problematic_24h":
        return getStoreListResponse(
          provider_circuits_today_repo.getPrimaryOnly24H()
        );
      case "pct_healthy_24h":
        return getStoreListResponse(
          provider_circuits_today_repo.getHealhyStore24H()
        );
      case "pct_excellent_24h":
        return getStoreListResponse(
          provider_circuits_today_repo.getStore100uptime24H()
        );
      case "third_only_7d":
        return getStoreListResponse(
          provider_circuits_today_repo.getThirdOnly7D()
        );
      case "third_only_24h":
        return getStoreListResponse(
          provider_circuits_today_repo.getThirdOnly24H()
        );
      default:
        return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
    }

    List<Map<String, Object>> siteDetailsList = circuitService.getStoreDataForSiteIds(
      siteList
    );
    ResponseEntity<List<Map<String, Object>>> responseEntity = new ResponseEntity<>(
      siteDetailsList,
      HttpStatus.OK
    );
    HttpStatus status = responseEntity.getStatusCode();
    // elasticLogService.saveWorkConnectLog(
    // auth,
    // "Api call - backend",
    // status.toString(),
    // "api/nms/getListing",
    // store
    // );
    return responseEntity;
  }

  private ResponseEntity<List<Map<String, Object>>> getStoreListResponse(
    List<Map<String, Object>> storeList
  ) {
    return new ResponseEntity<>(storeList, HttpStatus.OK);
  }

  @GetMapping("getMacAndGtwIp")
  public ResponseEntity<Map<String, Object>> getMacAndGtwIp(
    @RequestHeader(value = "Authorization", required = false) String auth,
    @RequestParam String storeId,
    @RequestParam String clientIp
  ) {
    try {
      Map<String, String> result = authService.isTokenValid(auth);
      if (result.get("status").equals("SUCCESS")) {
        if (authService.getRoles(auth).contains("ROLE_AUTO_DISCOVERY")) {
          String response = mac_retrieve_service.parseMacAndGtwIp(storeId);
          System.out.println("SSH Response: \n" + response);
          // Will update the exisitng mac address
          Map<String, Object> macAndPublicIp = provider_circuits_today_repo.findMacAndGtwBySiteId(
            storeId
          );

          elasticLogService.saveWorkConnectLog(
            auth,
            "Api call - backend",
            HttpStatus.OK.toString(),
            "api/nms/getMacAndGtwIp",
            storeId,
            clientIp
          );
          return new ResponseEntity<>(macAndPublicIp, HttpStatus.OK);
        } else {
          elasticLogService.saveWorkConnectLog(
            auth,
            "Api call - backend",
            HttpStatus.UNAUTHORIZED.toString(),
            "api/nms/getMacAndGtwIp",
            storeId,
            clientIp
          );
          return new ResponseEntity<>(
            Collections.singletonMap(
              "message",
              "USER NOT AUTHORIZED FOR PROVISION!"
            ),
            HttpStatus.UNAUTHORIZED
          );
        }
      }
    } catch (Exception e) {
      e.printStackTrace();
      return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
    return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
  }


    @GetMapping("providers")
      public List<Provider> getAllProviders() {
          System.out.println("Inside getAllProviders");
          return service.getAllProviders();
        }

  @GetMapping("getMacAndPublicIp")
  public ResponseEntity<Map<String, Object>> getMacAndPublicIp(
    @RequestHeader(value = "Authorization", required = false) String auth,
    @RequestParam String storeId,
    @RequestParam String clientIp
  ) {
    try {
      Map<String, String> result = authService.isTokenValid(auth);
      if (!result.get("status").equals("SUCCESS")) {
        return new ResponseEntity<>(
          Collections.singletonMap("message", "USER NOT AUTHORIZED!"),
          HttpStatus.UNAUTHORIZED
        );
      }
      if (!authService.getRoles(auth).contains("ROLE_AUTO_DISCOVERY")) {
        elasticLogService.saveWorkConnectLog(
          auth,
          "Api call - backend",
          HttpStatus.UNAUTHORIZED.toString(),
          "api/nms/getMacAndPublicIp",
          storeId,
          clientIp
        );
        return new ResponseEntity<>(
          Collections.singletonMap(
            "message",
            "USER NOT AUTHORIZED FOR PROVISION!"
          ),
          HttpStatus.UNAUTHORIZED
        );
      }

      Map<String, Object> macAndPublicIp = provider_circuits_today_repo.findMacAndPublicIpBySiteId(
        storeId
      );

      elasticLogService.saveWorkConnectLog(
        auth,
        "Api call - backend",
        HttpStatus.OK.toString(),
        "api/nms/getMacAndPublicIp",
        storeId,
        clientIp
      );
      return new ResponseEntity<>(macAndPublicIp, HttpStatus.OK);
    } catch (Exception e) {
      e.printStackTrace();
      return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

  // @GetMapping("getPingStore")
  // public ResponseEntity<Map<String, Object>> getPingStore(
  //   // @RequestHeader(value = "Authorization", required = false) String auth,
  //   @RequestParam String storeId
  // ) {
  //   // Map<String, String> result = authService.isTokenValid(auth);
  //   Map<String, Object> providerPing = new HashMap<>();
  //   // if (!result.get("status").equals("SUCCESS")) {
  //   // providerPing.put("message", "USER NOT AUTHORIZED FOR PROVISION!");
  //   // providerPing.put("status", 401);
  //   // return new ResponseEntity<>(providerPing, HttpStatus.UNAUTHORIZED);
  //   // }
  //   // if (!authService.getRoles(auth).contains("ROLE_AUTO_DISCOVERY")) {
  //   // elasticLogService.saveWorkConnectLog(
  //   // auth,
  //   // "Api call - backend",
  //   // HttpStatus.UNAUTHORIZED.toString(),
  //   // "api/nms/getPingStore",
  //   // storeId
  //   // );
  //   // providerPing.put("message", "USER NOT AUTHORIZED FOR PROVISION!");
  //   // providerPing.put("status", 401);
  //   // return new ResponseEntity<>(providerPing, HttpStatus.UNAUTHORIZED);
  //   // }
  //   String ip = util.getIpNetbox(storeId);
  //   String ping = mac_retrieve_service.pingStore(storeId);
  //   System.out.println(ping);

  //   providerPing.put("pingMsg", ping);

  //   if (
  //     util.isInRange(
  //       util.ipToInt(ip),
  //       util.ipToInt("10.9.32.0"),
  //       util.ipToInt("10.9.255.255")
  //     )
  //   ) {
  //     Pattern pattern = Pattern.compile("Active Provider:(.+)");
  //     Matcher matcher = pattern.matcher(ping);
  //     if (matcher.find()) {
  //       String provider = matcher.group(1);
  //       providerPing.put("provider", provider);
  //     }
  //   } else if (
  //     util.isInRange(
  //       util.ipToInt(ip),
  //       util.ipToInt("10.9.0.0"),
  //       util.ipToInt("10.9.31.255")
  //     )
  //   ) {}

  //   // elasticLogService.saveWorkConnectLog(
  //   // auth,
  //   // "Api call - backend",
  //   // HttpStatus.OK.toString(),
  //   // "api/nms/getPingStore",
  //   // storeId
  //   // );

  //   return new ResponseEntity<Map<String, Object>>(providerPing, HttpStatus.OK);
  // }

  @GetMapping("getPublicIp")
  public ResponseEntity<Map<String, Object>> getExecutePublicIpPlaybook(
    @RequestHeader(value = "Authorization", required = false) String auth,
    @RequestParam String storeId,
    @RequestParam String clientIp
  ) throws InterruptedException {
    Map<String, String> result = authService.isTokenValid(auth);
    if (!result.get("status").equals("SUCCESS")) {
      return new ResponseEntity<>(new HashMap<>(), HttpStatus.UNAUTHORIZED);
    }

    if (
      // authService.getRoles(auth).contains("default-roles-workconnect-staging")
      authService.getRoles(auth).contains("ROLE_AUTO_DISCOVERY")
    ) {
      String ip = util.getIpNetbox(storeId);
      String playbookType = util.isInRange(
          util.ipToInt(ip),
          util.ipToInt("10.9.32.0"),
          util.ipToInt("10.9.255.255")
        )
        ? "mikrotik"
        : "ruijie";
      String jobId = mac_retrieve_service.executePublicIpPlaybook(
        storeId,
        playbookType
      );
      Map<String, Object> publicIps = mac_retrieve_service.parsePublicIpPlaybook(
        jobId,
        storeId
      );
      HttpStatus status = HttpStatus.OK;

      elasticLogService.saveWorkConnectLog(
        auth,
        "Api call - backend",
        status.toString(),
        "api/nms/getPublicIp",
        storeId,
        clientIp
      );
      return new ResponseEntity<>(publicIps, status);
    } else {
      HttpStatus status = HttpStatus.UNAUTHORIZED;
      elasticLogService.saveWorkConnectLog(
        auth,
        "Api call - backend",
        status.toString(),
        "api/nms/getPublicIp",
        storeId,
        clientIp
      );
      return new ResponseEntity<>(new HashMap<>(), status);
    }
  }

  @GetMapping("getLoopbacks")
  private String[] getIps(
    @RequestHeader(value = "Authorization", required = false) String auth,
    @RequestParam(value = "clientIp", required = false) String clientIp,
    @RequestParam String storeId
  ) throws IOException {
    elasticLogService.saveWorkConnectLog(
      auth,
      "Api call - backend",
      HttpStatus.OK.toString(),
      "api/autodiscover/getLoopbacksIps",
      storeId,
      clientIp
    );

    String lo0 = circuitService.getLoopbackIp(storeId, 0);
    String lo1 = circuitService.getLoopbackIp(storeId, 1);
    String lo2 = circuitService.getLoopbackIp(storeId, 2);

    String pinglo0 = mac_retrieve_service.pingLoopbackIps(lo0);
    String pinglo1 = mac_retrieve_service.pingLoopbackIps(lo1);
    String pinglo2 = mac_retrieve_service.pingLoopbackIps(lo2);

    List<String> combinedResults = new ArrayList<>();
    combinedResults.add(pinglo0);
    combinedResults.add(pinglo1);
    combinedResults.add(pinglo2);

    String[] allPingResults = combinedResults.toArray(new String[0]);
    return allPingResults;
  }

  @GetMapping("getTraceRoute")
  public ResponseEntity<String> getTraceRoute(
    @RequestHeader(value = "Authorization", required = false) String auth,
    @RequestParam(value = "clientIp", required = false) String clientIp,
    @RequestParam String storeId,
    @RequestParam String type
  ) {
    String tracerouteResponse = "";
    elasticLogService.saveWorkConnectLog(
      auth,
      "Api call - backend",
      HttpStatus.OK.toString(),
      "api/autodiscover/getSNMP",
      storeId + " " + type,
      clientIp
    );

    if (type.equals("store")) {
      tracerouteResponse = mac_retrieve_service.traceRoute(storeId, type);
    }
    if (type.equals("primary")) {
      tracerouteResponse = mac_retrieve_service.traceRoute(storeId, type);
    }
    if (type.equals("backup")) {
      tracerouteResponse = mac_retrieve_service.traceRoute(storeId, type);
    }
    System.out.println(type + " " + tracerouteResponse);

    return new ResponseEntity<String>(tracerouteResponse, HttpStatus.OK);
  }

  @GetMapping("/getProviderInventory")
  public ResponseEntity<List<Map<String, Object>>> getProviderInventory(
    @RequestParam String provider
  ) {
    List<Map<String, Object>> inventory = atis_inventory_repo.getListByProvider(
      provider
    );
    System.out.println(inventory);
    return new ResponseEntity<>(inventory, HttpStatus.OK);
  }

  @GetMapping("/getDownCircuitsPrimary")
  public List<Map<String, Object>> getDownCircuitsPrimary()
    throws JSONException, ParseException {
    List<Map<String, Object>> result = new ArrayList<>();
    List<Map<String, Object>> resultCircuit = new ArrayList<>();

    List<String> siteIds = circuitService.getAllDownPrimarySiteId();

    result = zabbix_helper.classifySitesLastChange(siteIds, "primary");

    List<Map<String, Object>> providers = provider_circuits_today_repo.getPrimaryProvider(
      siteIds
    );
    for (Map<String, Object> provider : providers) {
      Map<String, Object> obj = new HashMap<>();
      obj.put("site_id", provider.get("site_id"));
      obj.put("provider", provider.get("provider_primary"));
      resultCircuit.add(obj);
    }

    List<Map<String, Object>> combinedResult = new ArrayList<>();
    for (Map<String, Object> res : result) {
      String siteId = (String) res.get("site_id");

      for (Map<String, Object> circuit : resultCircuit) {
        if (siteId.equals(circuit.get("site_id"))) {
          Map<String, Object> combinedMap = new HashMap<>();
          combinedMap.putAll(res);
          combinedMap.put("provider", circuit.get("provider"));
          combinedResult.add(combinedMap);
          break;
        }
      }
    }

    System.out.println("Down Primary: " + siteIds.size());

    return combinedResult;
  }

  @GetMapping("/getDownCircuitsBackup")
  public List<Map<String, Object>> getDownCircuitsBackup()
    throws JSONException, ParseException {
    List<Map<String, Object>> result = new ArrayList<>();
    List<Map<String, Object>> resultCircuit = new ArrayList<>();

    List<String> siteIds = circuitService.getAllDownBackupSiteId();

    result = zabbix_helper.classifySitesLastChange(siteIds, "backup");

    List<Map<String, Object>> providers = provider_circuits_today_repo.getBackupProvider(
      siteIds
    );
    for (Map<String, Object> provider : providers) {
      Map<String, Object> obj = new HashMap<>();
      obj.put("site_id", provider.get("site_id"));
      obj.put("provider", provider.get("provider_backup"));
      resultCircuit.add(obj);
    }

    List<Map<String, Object>> combinedResult = new ArrayList<>();
    for (Map<String, Object> res : result) {
      String siteId = (String) res.get("site_id");

      for (Map<String, Object> circuit : resultCircuit) {
        if (siteId.equals(circuit.get("site_id"))) {
          Map<String, Object> combinedMap = new HashMap<>();
          combinedMap.putAll(res);
          combinedMap.put("provider", circuit.get("provider"));
          combinedResult.add(combinedMap);
          break;
        }
      }
    }

    System.out.println("Down Backup: " + siteIds.size());

    return combinedResult;
  }
  
}
