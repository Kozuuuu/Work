import axios from 'axios'

const http = axios.create({
  baseURL: process.env.VUE_APP_WORKCONNECT_API_URL,
  // timeout: 25000,
  headers: {
    "Content-type": "application/json",
    //Authorization: `${$keycloak.token}`,
  }
})


export { http }