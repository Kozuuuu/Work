#Dockerfile for WCFE
FROM node:16.20.2-alpine AS BUILD

RUN apk --no-cache add git

WORKDIR /usr/src/app/workconnect-fe

COPY . /usr/src/app

ARG VUE_APP_KEYCLOAK_REALM
ARG VUE_APP_KEYCLOAK_URL
ARG VUE_APP_KEYCLOAK_CLIENT_ID
ARG VUE_APP_WORKCONNECT_API_URL
ARG VUE_APP_BASE_URL
ARG VUE_APP_VUE_ROUTER_MODE


ENV VUE_APP_KEYCLOAK_REALM=$VUE_APP_KEYCLOAK_REALM
ENV VUE_APP_KEYCLOAK_URL=$VUE_APP_KEYCLOAK_URL
ENV VUE_APP_KEYCLOAK_CLIENT_ID=$VUE_APP_KEYCLOAK_CLIENT_ID
ENV VUE_APP_WORKCONNECT_API_URL=$VUE_APP_WORKCONNECT_API_URL
ENV VUE_APP_BASE_URL=$VUE_APP_BASE_URL
ENV VUE_APP_VUE_ROUTER_MODE=$VUE_APP_VUE_ROUTER_MODE

RUN echo VUE_APP_KEYCLOAK_REALM  >> /usr/src/app/workconnect-fe/.env
RUN echo VUE_APP_KEYCLOAK_URL  >> /usr/src/app/workconnect-fe/.env
RUN echo VUE_APP_KEYCLOAK_CLIENT_ID  >> /usr/src/app/workconnect-fe/.env
RUN echo VUE_APP_WORKCONNECT_API_URL  >> /usr/src/app/workconnect-fe/.env
RUN echo VUE_APP_BASE_URL  >> /usr/src/app/workconnect-fe/.env
RUN echo VUE_APP_VUE_ROUTER_MODE  >> /usr/src/app/workconnect-fe/.env


RUN npm install --force
RUN npm install -g @quasar/cli
#RUN npm update -g @quasar/cli
#RUN npm install caniuse-lite
RUN quasar build

FROM nginx:1.21.0-alpine

RUN mkdir -p /opt/workconnect

COPY --from=BUILD /usr/src/app/workconnect-fe/dist /opt/workconnect

COPY --from=BUILD /usr/src/app/workconnect-fe/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

EXPOSE 443
