import { defineStore } from "pinia";
import { ref, computed } from "vue";
export const useSampleCountStore = defineStore("sample-count", () => {
  const randomNumber = () => Math.floor(Math.random() * 1000 + 1);

  const totalDownStore = [
    {
      title: "Total Down Stores",
      value: randomNumber(),
      picolor: "#006ca5",
      routeValue: "",
      bigSize: true,
    },
    {
      title: "Mikrotik Down Stores",
      value: randomNumber(),
      picolor: "#0496c7",
      routeValue: "",
    },
    {
      title: "Ruijie Down Stores",
      value: randomNumber(),
      picolor: "#0496c7",
      routeValue: "",
    },
    {
      title: "Down Stores [Prometheus]",
      value: randomNumber(),
      picolor: "#0496c7",
      routeValue: "",
    },
  ];

  const problematicStores = [
    {
      title: "Total Problematic Stores",
      value: randomNumber(),
      picolor: "#006ca5",
      routeValue: "",
      bigSize: true,
    },
    {
      title: "uptime availability < 95%",
      value: randomNumber(),
      picolor: "#0496c7",
      routeValue: "",
    },
    {
      title: "Wireless Only",
      value: randomNumber(),
      picolor: "#0496c7",
      routeValue: "",
    },
    {
      title: "Single Circuit",
      value: randomNumber(),
      picolor: "#0496c7",
      routeValue: "",
    },
    {
      title: "Dual Circuit",
      value: randomNumber(),
      picolor: "#0496c7",
      routeValue: "",
    },
  ];

  const primaryCircuit = [
    {
      title: "Total Problematic Circuits",
      value: randomNumber(),
      picolor: "#006ca5",
      routeValue: "",
      bigSize: true,
    },
    {
      title: "No circuit",
      value: randomNumber(),
      picolor: "#0496c7",
      routeValue: "",
    },
    {
      title: "No internet",
      value: randomNumber(),
      picolor: "#0496c7",
      routeValue: "",
    },
    {
      title: "Intermittent",
      value: randomNumber(),
      picolor: "#0496c7",
      routeValue: "",
    },
    {
      title: "Wireless circuit ",
      value: randomNumber(),
      picolor: "#0496c7",
      routeValue: "",
    },
  ];
  const backupCircuit = [
    {
      title: "Total Problematic Circuits",
      value: randomNumber(),
      picolor: "#006ca5",
      routeValue: "",
      bigSize: true,
    },
    {
      title: "No circuit",
      value: randomNumber(),
      picolor: "#0496c7",
      routeValue: "",
    },
    {
      title: "No internet",
      value: randomNumber(),
      picolor: "#0496c7",
      routeValue: "",
    },
    {
      title: "Intermittent",
      value: randomNumber(),
      picolor: "#0496c7",
      routeValue: "",
    },
    {
      title: "Wired circuit ",
      value: randomNumber(),
      picolor: "#0496c7",
      routeValue: "",
    },
  ];

  return {
    backupCircuit,
    primaryCircuit,
    problematicStores,
    totalDownStore,
  };
});
