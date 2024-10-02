import axios from "axios";
import { getCLientIp } from "./api";
//////////////
// MIKROTIK //
//////////////

interface playbookRes {
  message: string;
  status: string;
  jobId: number;
}

export const mngnmtVpn = async (
  storeId: string,
  ansibleHost: string
): Promise<playbookRes> => {
  const { data } = await axios.post("/api/playbook/mngnmtVpn", null, {
    params: {
      storeId,
      ansibleHost,
      clientIp: await getCLientIp(),
    },
  });

  return data;
};

export const GTv3 = async (
  storeId: string,
  ansibleHost: string
): Promise<playbookRes> => {
  const { data } = await axios.post("/api/playbook/GTv3", null, {
    params: {
      storeId,
      ansibleHost,
      clientIp: await getCLientIp(),
    },
  });

  return data;
};

////////////
// RUIJIE //
////////////
export const ruijieV3 = async (
  storeId: string,
  ansibleHost: string
): Promise<playbookRes> => {
  const { data } = await axios.post("/api/playbook/ruijieV3", null, {
    params: {
      storeId,
      ansibleHost,
      clientIp: await getCLientIp(),
    },
  });

  return data;
};

//////////////
// REUSABLE //
//////////////

export const onBoarding = async (
  storeId: string,
  jobId: number
): Promise<playbookRes> => {
  const { data } = await axios.post("/api/playbook/onBoarding", null, {
    params: {
      storeId: storeId,
      jobId: jobId,
      clientIp: await getCLientIp(),
    },
  });

  return data;
};

export const offBoardingStore = async (storeId: string) => {
  const { data } = await axios.post("/api/playbook/offBoarding", null, {
    params: {
      storeId: storeId,
      clientIp: await getCLientIp(),
    },
  });

  return data;
};

export const updateStoreStatus = async (storeId: string, status: string) => {
  const { data } = await axios.post("/api/playbook/updateStoreStatus", null, {
    params: {
      storeId: storeId,
      storeStatus: status,
      clientIp: await getCLientIp(),
    },
  });

  return data;
};

// export const provisionGTv3 = async (
//   storeId: string,
//   ipAdd: string,
//   routerType: string
// ) => {
//   const { data } = await axios.post("/api/playbook/provisionGTv3", null, {
//     params: {
//       storeId: storeId,
//       ansibleHost: ipAdd,
//       routerType: routerType,
//     },
//   });

//   return data;
// };
