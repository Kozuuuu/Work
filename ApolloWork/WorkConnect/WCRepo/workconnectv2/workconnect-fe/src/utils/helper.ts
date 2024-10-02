import { computed } from "vue";
import { insertWorkconnectLog } from "src/api/api";
import { useSiteStore } from "src/stores/sites/stores";
import moment from "moment-timezone";
import { QSpinnerDots } from "quasar";
import { color } from "echarts";

import { auth } from "src/stores/auth";
import { storeToRefs } from "pinia";
const auths = auth();
const { keycloak } = storeToRefs(auths);

export const store = useSiteStore();

export const isNoData = (value: number): string => {
  return value <= -1 ? "N/A" : (Number(value) * 100).toFixed(0) + "%";
};

export const formatDate = (dateTimeString: string): string => {
  const options: Intl.DateTimeFormatOptions = {
    year: "numeric",
    month: "long",
    day: "numeric",
    hour: "numeric",
    minute: "numeric",

    hour12: true,
  };
  const formattedDate = new Date(dateTimeString).toLocaleString(
    undefined,
    options
  );
  return formattedDate;
};

export const uptimeToDuration7D = (value: number): string => {
  if (value >= 0) {
    const downPercent = 1.0 - value;
    const downSeconds = Math.floor(604800 * downPercent);

    const days = Math.floor(downSeconds / 86400);
    const hours = Math.floor((downSeconds % 86400) / 3600);
    const minutes = Math.floor((downSeconds % 3600) / 60);

    const formatTime = (time: number, unit: string) => {
      return time > 0 ? `${time}${unit}` : "";
    };

    const formattedDuration = [
      formatTime(days, "d"),
      formatTime(hours, "h"),
      formatTime(minutes, "m"),
    ]
      .filter(Boolean)
      .join(" ");

    return formattedDuration || "0";
  }
  return "NO DATA";
};

export const uptimeToDuration24H = (value: number): string => {
  if (value >= 0) {
    const downPercent = 1.0 - value;
    const downSeconds = Math.floor(86400 * downPercent);

    const hours = Math.floor(downSeconds / 3600);
    const minutes = Math.floor((downSeconds % 3600) / 60);

    const formatTime = (time: number, unit: string) => {
      return time > 0 ? `${time}${unit}` : "";
    };

    const formattedDuration = [formatTime(hours, "h"), formatTime(minutes, "m")]
      .filter(Boolean)
      .join(" ");

    return formattedDuration || "0";
  }
  return "NO DATA";
};

// export const calculateDownTime = (downTime: string | null): { days: number } | string => {
//   if (!downTime || downTime == "Cannot be determined") {
//     return "UP on Zabbix";
//   }

//   const downDate = new Date(downTime);
//   const currentDate = new Date();
//   const timeDifference = Math.abs(currentDate.getTime() - downDate.getTime());
//   const days = Math.floor(timeDifference / (1000 * 60 * 60 * 24));
//   const hours = Math.floor(
//     (timeDifference % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)
//   );
//   const minutes = Math.floor((timeDifference % (1000 * 60 * 60)) / (1000 * 60));

//   let timeString = "";
//   if (days > 0) {
//     timeString += `${days} days, `;
//   }
//   timeString += `${hours} hours, and ${minutes} minutes`;

//   return timeString;
// };

export interface DownTimeResult {
  days: number;
  timeString: string;
}

export const calculateDownTime = (
  downTime: string | null | number
): { days: number; timeString: string } | string => {
  if (!downTime || downTime == "Cannot be determined") {
    return "UP on Zabbix";
  }

  const downDate = new Date(downTime);
  const currentDate = new Date();
  const timeDifference = Math.abs(currentDate.getTime() - downDate.getTime());
  const days = Math.floor(timeDifference / (1000 * 60 * 60 * 24));
  const hours = Math.floor(
    (timeDifference % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)
  );
  const minutes = Math.floor((timeDifference % (1000 * 60 * 60)) / (1000 * 60));

  let timeString = "";
  if (days > 0) {
    timeString += `${days} days, `;
  }
  timeString += `${hours} hours, and ${minutes} minutes`;

  return { days, timeString } as DownTimeResult;
};

// export const notif401 = () => {
//   $q.notify({
//     message: "Unauthorized Access Request failed with Status Code 401",
//     color: "negative",
//   });
// };

export const secondsToMinutes = (seconds: number) => {
  let minutes: number = Math.floor(seconds / 60);
  let remainingSeconds: number = Math.floor(seconds % 60);
  let formattedMinutes: string =
    minutes < 10 ? "0" + minutes.toString() : minutes.toString();
  let formattedSeconds: string =
    remainingSeconds < 10
      ? "0" + remainingSeconds.toString()
      : remainingSeconds.toString();
  return `${formattedMinutes} m ${formattedSeconds} s`;
};

export const hasPermission = (authorities: string[]) => {
  return authorities.some((authority) =>
    // @ts-ignore
    keycloak.value.realmAccess.roles.includes(authority)
  );
};

export const timeDifference = (epochInSeconds: number) => {
  const epochInMillis = epochInSeconds * 1000;
  const currentDate = new Date();

  const currentTimeInMillis = currentDate.getTime();

  const timeDifferenceInMillis = currentTimeInMillis - epochInMillis;

  const secondsDifference = Math.floor(timeDifferenceInMillis / 1000);
  const minutesDifference = Math.floor(secondsDifference / 60);
  const hoursDifference = Math.floor(minutesDifference / 60);
  const daysDifference = Math.floor(hoursDifference / 24);
  const monthsDifference = Math.floor(daysDifference / 30);

  let timeDifferenceString = "";
  if (monthsDifference > 0) {
    timeDifferenceString += monthsDifference + " MO, ";
  }
  if (daysDifference > 0) {
    timeDifferenceString += (daysDifference % 30) + " D, ";
  }
  if (hoursDifference > 0) {
    timeDifferenceString += (hoursDifference % 24) + " H, ";
  }
  if (minutesDifference > 0) {
    timeDifferenceString += (minutesDifference % 60) + " m";
  }

  return timeDifferenceString;
};
