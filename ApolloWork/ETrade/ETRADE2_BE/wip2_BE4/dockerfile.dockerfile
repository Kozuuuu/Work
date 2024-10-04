# FROM python AS deps

# RUN pip install gdown
# RUN gdown https://drive.google.com/uc?id=1fqOwuOZNx3rCyAE3PMotoqkmYNzjythk
# RUN gdown https://drive.google.com/uc?id=1xHiCgKUBgGizHPLxhONGr11tv4EUz_iA

# FROM ubuntu:latest

# ENV SDKMAN_DIR="/root/.sdkman"
# ENV SDKMAN_INIT="$SDKMAN_DIR/bin/sdkman-init.sh"
# ENV _JAVA_OPTIONS="-Xmx1024m"
# ENV JAVA_OPTS="-Xmx2g -XX:MaxPermSize=1540m -Dstringchararrayaccessor.disabled=true"

# RUN apt-get update -y \
#     && apt-get -y install bash curl tar wget unzip zip unrar \
#     && rm /bin/sh \
#     && ln -s /bin/bash /bin/sh \
#     && curl -s "https://get.sdkman.io" | bash \
#     && bash -c "source $SDKMAN_INIT && sdk install java 7.0.352-zulu && sdk install grails 1.3.7" \
#     && bash -c "apt-get install apache2" \
#     && bash -c "apt-get install Unzip"


# RUN cd /tmp/ \
#     && curl -O https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.70/bin/apache-tomcat-7.0.70.tar.gz \
#     && mkdir /var/lib/tomcat7/ \
#     && tar xzvf apache-tomcat-7.0.70.tar.gz -C /var/lib/tomcat7 --strip-components=1

# RUN groupadd tomcat7 \
#     && useradd -s /bin/false -g tomcat7 -d /var/lib/tomcat7 tomcat7
	
# RUN cd /var/lib/tomcat7 \
#     && chgrp -R tomcat7 conf \
#     && chmod g+rwx conf \
#     && chmod g+r conf/* \
#     && chown -R tomcat7 work/ temp/ logs/ 

# RUN cat <<EOF > /etc/systemd/system/tomcat7.service
# [Unit]
# Description=Apache Tomcat Web Application Container
# After=network.target

# [Service]
# Type=forking

# Environment=JAVA_HOME=/usr/lib/jvm/zulu7-ca-amd64/jre
# Environment=CATALINA_PID=/var/lib/tomcat7/temp/tomcat.pid
# Environment=CATALINA_HOME=/var/lib/tomcat7
# Environment=CATALINA_BASE=/var/lib/tomcat7
# Environment='CATALINA_OPTS=-Xmx7168M -Xms7168M -XX:PermSize=512m -XX:MaxPermSize=512m -XX:NewSize=256m -server -XX:+UseParallelGC'

# ExecStart=/var/lib/tomcat7/bin/startup.sh
# ExecStop=/var/lib/tomcat7/bin/shutdown.sh

# User=tomcat7
# Group=tomcat7
# UMask=0007
# RestartSec=10
# Restart=always

# WorkingDirectory=/var/lib/tomcat7


# [Install]
# WantedBy=multi-user.target
# EOF

# RUN systemctl daemon-reload

# RUN touch /var/lib/tomcat7stacktrace.log \
#     &&  chown -R tomcat7:tomcat7 /var/lib/tomcat7/stacktrace.log

# RUN mkdir /var/lib/tomcat7/acos_incoming_dir \
#     /var/lib/tomcat7/acos_outgoing_dir \
#     /var/lib/tomcat7/acos_unl_dir \
#     /var/lib/tomcat7/ccbi_outgoing_dir \
#     /var/lib/tomcat7/disabled_jobs_dir \
#     /var/lib/tomcat7/e2m_af_incoming_dir \
#     /var/lib/tomcat7/e2m_al_incoming_dir \
#     /var/lib/tomcat7/e2m_incoming_dir \
#     /var/lib/tomcat7/e2m_manifest_incoming_dir \
#     /var/lib/tomcat7/e2m_olrs_incoming_dir \
#     /var/lib/tomcat7/e2m_sf_incoming_dir \
#     /var/lib/tomcat7/e2m_sl_incoming_dir \
#     /var/lib/tomcat7/e2m_unl_dir \
#     /var/lib/tomcat7/e2m_uploaded_dir \
#     /var/lib/tomcat7/eips_incoming_dir \
#     /var/lib/tomcat7/eips_outgoing_dir \
#     /var/lib/tomcat7/email_xml_incoming_dir \
#     /var/lib/tomcat7/fedex_uploaded \
#     /var/lib/tomcat7/ftpscript \
#     /var/lib/tomcat7/gofast_sl \
#     /var/lib/tomcat7/manifest_port_outgoing_dir \
#     /var/lib/tomcat7/Q2 \
#     /var/lib/tomcat7/response_report_outgoing_dir \
#     /var/lib/tomcat7/seed \
#     /var/lib/tomcat7/temp_errorFolder \
#     /var/lib/tomcat7/tempFolder \
#     /var/lib/tomcat7/war_for_deployment \
#     /var/lib/tomcat7/ftp_in \
#     /var/lib/tomcat7/ftp_in/aspac\
#     /var/lib/tomcat7/ftp_in/cathaypac \
#     /var/lib/tomcat7/ftp_in/thaiair \
#     /var/lib/tomcat7/ftp_in/yusena \
#     /var/lib/tomcat7/acop_tp \
#     /var/lib/tomcat7/aspac_uploaded \
#     /var/lib/tomcat7/cbw_outgoing_dir \
#     /var/lib/tomcat7/cdc_incoming_dir \
#     /var/lib/tomcat7/cdc_outgoing_dir \
#     /var/lib/tomcat7/cts_outgoing_dir \
#     /var/lib/tomcat7/cts_temp_dir \
#     /var/lib/tomcat7/cts_temp_outgoing_dir \
#     /var/lib/tomcat7/e2m_abms_ledger_incoming_dir \
#     /var/lib/tomcat7/e2m_callback_incoming_dir \
#     /var/lib/tomcat7/e2m_outgoing_dir \
#     /var/lib/tomcat7/egdvs_incoming_dir \
#     /var/lib/tomcat7/eips_uploaded_dir \
#     /var/lib/tomcat7/manifest_port5j_outgoing_dir \
#     /var/lib/tomcat7/scripts \
#     /var/lib/tomcat7/temp_af_incoming \
#     /var/lib/tomcat7/temp_al_incoming \
#     /var/lib/tomcat7/temp_errorFolder_tnt \
#     /var/lib/tomcat7/temp_incoming \
#     /var/lib/tomcat7/temp_reprocess \
#     /var/lib/tomcat7/tempResponse \
#     /var/lib/tomcat7/cts_sf_incoming_dir \
#     /var/lib/tomcat7/cts_sl_incoming_dir \
#     /var/lib/tomcat7/e2m_abms_temp_incoming \
#     /var/lib/tomcat7/etrade_incoming_dir \
#     /var/lib/tomcat7/etrade_outgoing_dir \
#     /var/lib/tomcat7/etrade_uploaded_dir \
#     /var/lib/tomcat7/peza_ed_outgoing_dir \
#     /var/lib/tomcat7/peza_ed_uploaded_dir \
#     /var/lib/tomcat7/peza_outgoing_dir \
#     /var/lib/tomcat7/peza_uploaded_dir


# RUN chown -R tomcat7: /var/lib/tomcat7/acos_incoming_dir \
#     /var/lib/tomcat7/acos_outgoing_dir \
#     /var/lib/tomcat7/acos_unl_dir \
#     /var/lib/tomcat7/ccbi_outgoing_dir \
#     /var/lib/tomcat7/disabled_jobs_dir \
#     /var/lib/tomcat7/e2m_af_incoming_dir \
#     /var/lib/tomcat7/e2m_al_incoming_dir \
#     /var/lib/tomcat7/e2m_incoming_dir \
#     /var/lib/tomcat7/e2m_manifest_incoming_dir \
#     /var/lib/tomcat7/e2m_olrs_incoming_dir \
#     /var/lib/tomcat7/e2m_sf_incoming_dir \
#     /var/lib/tomcat7/e2m_sl_incoming_dir \
#     /var/lib/tomcat7/e2m_unl_dir \
#     /var/lib/tomcat7/e2m_uploaded_dir \
#     /var/lib/tomcat7/eips_incoming_dir \
#     /var/lib/tomcat7/eips_outgoing_dir \
#     /var/lib/tomcat7/email_xml_incoming_dir \
#     /var/lib/tomcat7/fedex_uploaded \
#     /var/lib/tomcat7/ftpscript \
#     /var/lib/tomcat7/gofast_sl \
#     /var/lib/tomcat7/manifest_port_outgoing_dir \
#     /var/lib/tomcat7/Q2 \
#     /var/lib/tomcat7/response_report_outgoing_dir \
#     /var/lib/tomcat7/seed \
#     /var/lib/tomcat7/temp_errorFolder \
#     /var/lib/tomcat7/tempFolder \
#     /var/lib/tomcat7/war_for_deployment \
#     /var/lib/tomcat7/ftp_in \
#     /var/lib/tomcat7/ftp_in/aspac \
#     /var/lib/tomcat7/ftp_in/cathaypac \
#     /var/lib/tomcat7/ftp_in/thaiair \
#     /var/lib/tomcat7/ftp_in/yusena \
#     /var/lib/tomcat7/acop_tp \
#     /var/lib/tomcat7/aspac_uploaded \
#     /var/lib/tomcat7/cbw_outgoing_dir \
#     /var/lib/tomcat7/cdc_incoming_dir \
#     /var/lib/tomcat7/cdc_outgoing_dir \
#     /var/lib/tomcat7/cts_outgoing_dir \
#     /var/lib/tomcat7/cts_temp_dir \
#     /var/lib/tomcat7/cts_temp_outgoing_dir \
#     /var/lib/tomcat7/e2m_abms_ledger_incoming_dir \
#     /var/lib/tomcat7/e2m_callback_incoming_dir \
#     /var/lib/tomcat7/e2m_outgoing_dir \
#     /var/lib/tomcat7/egdvs_incoming_dir \
#     /var/lib/tomcat7/eips_uploaded_dir \
#     /var/lib/tomcat7/manifest_port5j_outgoing_dir \
#     /var/lib/tomcat7/scripts \
#     /var/lib/tomcat7/temp_af_incoming \
#     /var/lib/tomcat7/temp_al_incoming \
#     /var/lib/tomcat7/temp_errorFolder_tnt \
#     /var/lib/tomcat7/temp_incoming \
#     /var/lib/tomcat7/temp_reprocess \
#     /var/lib/tomcat7/tempResponse \
#     /var/lib/tomcat7/cts_sf_incoming_dir \
#     /var/lib/tomcat7/cts_sl_incoming_dir \
#     /var/lib/tomcat7/e2m_abms_temp_incoming \
#     /var/lib/tomcat7/etrade_incoming_dir \
#     /var/lib/tomcat7/etrade_outgoing_dir \
#     /var/lib/tomcat7/etrade_uploaded_dir \
#     /var/lib/tomcat7/peza_ed_outgoing_dir \
#     /var/lib/tomcat7/peza_ed_uploaded_dir \
#     /var/lib/tomcat7/peza_outgoing_dir \
#     /var/lib/tomcat7/peza_uploaded_dir

# RUN chmod -R 755 /var/lib/tomcat7/acos_incoming_dir \
#     /var/lib/tomcat7/acos_outgoing_dir \
#     /var/lib/tomcat7/acos_unl_dir \
#     /var/lib/tomcat7/ccbi_outgoing_dir \
#     /var/lib/tomcat7/e2m_af_incoming_dir \
#     /var/lib/tomcat7/e2m_al_incoming_dir \
#     /var/lib/tomcat7/e2m_incoming_dir \
#     /var/lib/tomcat7/e2m_manifest_incoming_dir \
#     /var/lib/tomcat7/e2m_olrs_incoming_dir \
#     /var/lib/tomcat7/e2m_sf_incoming_dir \
#     /var/lib/tomcat7/e2m_sl_incoming_dir \
#     /var/lib/tomcat7/e2m_unl_dir \
#     /var/lib/tomcat7/e2m_uploaded_dir \
#     /var/lib/tomcat7/eips_incoming_dir \
#     /var/lib/tomcat7/eips_outgoing_dir \
#     /var/lib/tomcat7/email_xml_incoming_dir \
#     /var/lib/tomcat7/gofast_sl \
#     /var/lib/tomcat7/manifest_port_outgoing_dir \
#     /var/lib/tomcat7/response_report_outgoing_dir \
#     /var/lib/tomcat7/seed \
#     /var/lib/tomcat7/acop_tp \
#     /var/lib/tomcat7/aspac_uploaded \
#     /var/lib/tomcat7/cbw_outgoing_dir \
#     /var/lib/tomcat7/cdc_incoming_dir \
#     /var/lib/tomcat7/cdc_outgoing_dir \
#     /var/lib/tomcat7/cts_outgoing_dir \
#     /var/lib/tomcat7/cts_temp_dir \
#     /var/lib/tomcat7/cts_temp_outgoing_dir \
#     /var/lib/tomcat7/e2m_callback_incoming_dir \
#     /var/lib/tomcat7/e2m_outgoing_dir \
#     /var/lib/tomcat7/egdvs_incoming_dir \
#     /var/lib/tomcat7/eips_uploaded_dir \
#     /var/lib/tomcat7/manifest_port5j_outgoing_dir \
#     /var/lib/tomcat7/scripts \
#     /var/lib/tomcat7/temp_af_incoming \
#     /var/lib/tomcat7/temp_al_incoming \
#     /var/lib/tomcat7/temp_errorFolder_tnt \
#     /var/lib/tomcat7/temp_incoming \
#     /var/lib/tomcat7/temp_reprocess \
#     /var/lib/tomcat7/tempResponse \
#     /var/lib/tomcat7/cts_sf_incoming_dir \
#     /var/lib/tomcat7/cts_sl_incoming_dir \
#     /var/lib/tomcat7/e2m_abms_temp_incoming \
#     /var/lib/tomcat7/peza_outgoing_dir \
#     /var/lib/tomcat7/peza_uploaded_dir

# RUN chmod -R 777 \
#     /var/lib/tomcat7/disabled_jobs_dir \
#     /var/lib/tomcat7/fedex_uploaded \
#     /var/lib/tomcat7/ftpscript \
#     /var/lib/tomcat7/Q2 \
#     /var/lib/tomcat7/temp_errorFolder \
#     /var/lib/tomcat7/tempFolder \
#     /var/lib/tomcat7/war_for_deployment \
#     /var/lib/tomcat7/ftp_in \
#     /var/lib/tomcat7/ftp_in/aspac \
#     /var/lib/tomcat7/ftp_in/cathaypac \
#     /var/lib/tomcat7/ftp_in/thaiair \
#     /var/lib/tomcat7/ftp_in/yusena \
#     /var/lib/tomcat7/e2m_abms_ledger_incoming_dir \
#     /var/lib/tomcat7/etrade_incoming_dir \
#     /var/lib/tomcat7/etrade_outgoing_dir \
#     /var/lib/tomcat7/etrade_uploaded_dir \
#     /var/lib/tomcat7/peza_ed_outgoing_dir \
#     /var/lib/tomcat7/peza_ed_uploaded_dir

# RUN touch /var/lib/tomcat7/disabled_jobs_dir/AbmsLedgerProcessing.disableNOT && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/AcosResponseProcessing.disable && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/AcosUnlProcessing.disable && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/AirlineManifestResponseProcessing.disable && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/AirManifestAutoSending.disable && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/AirManifestResponseProcessing.disable && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/AirManifestSchedulerProcessing.disable && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/AutomatedCusdecProccessing.disable && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/CallbackProcessing.disable && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/CCBICusdecForwarding.disable && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/CloudProcessing.disable && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/CountTransaction.disable && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/CprsProcessing.disable && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/E2mResponseProcessing.disable && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/E2mUnlProcessing.disable && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/EgdvsProcessing.disable && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/EipsProcessing.disable && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/EmailXmlProcessing.disableNOT && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/InformalEntryProcessing.disable && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/ManifestResponseProcessing.disable && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/OlrsProcessing.disable && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/PezaStatusUpdateProcessing.disable && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/SeaManifestResponseProcessing.disableNOT && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/SftpProcessing.disable && \
#     touch /var/lib/tomcat7/disabled_jobs_dir/ShippinglineManifestResponseProcessing.disableNOT

# RUN chmod -R 744 /var/lib/tomcat7/disabled_jobs_dir
	
# RUN chown -R tomcat7: /var/lib/tomcat7/disabled_jobs_dir

# RUN mkdir /var/tmp/e2m \
#     /var/tmp/e2m/bol /var/tmp/e2m/cusdec \
#     /var/tmp/e2m/manifest \
#     /var/tmp/e2m/olrs \
#     /var/tmp/e2m/transit_permit
	
# RUN chown -R tomcat7: /var/tmp/e2m \
#     /var/tmp/e2m/bol \
#     /var/tmp/e2m/cusdec \
#     /var/tmp/e2m/manifest \
#     /var/tmp/e2m/olrs \
#     /var/tmp/e2m/transit_permit
	
# RUN chmod -R 755 /var/tmp/e2m \
#     /var/tmp/e2m/bol \
#     /var/tmp/e2m/cusdec \
#     /var/tmp/e2m/manifest \
#     /var/tmp/e2m/olrs \
#     /var/tmp/e2m/transit_permit

# RUN scp root@192.168.43.174:/var/lib/tomcat7/war_for_deployment/* /var/lib/tomcat7/war_for_deployment \
#     && scp root@192.168.43.174:/var/lib/tomcat7/ftpscript/*.sh /var/lib/tomcat7/ftpscript/ \
#     && scp root@192.168.43.174:/var/lib/tomcat7/scripts/*.sh /var/lib/tomcat7/scripts/ \
#     && scp root@192.168.43.174:/var/lib/tomcat7/ftpscript/xml.keystore /var/lib/tomcat7/ftpscript/ \
#     && scp root@192.168.43.174:/var/www/html/dtd/* /var/www/html/dtd/

# RUN cat <<EOF > /etc/hosts
# 192.168.43.174   strategyobject.com

# #PENTAHO DB
# 192.168.19.51   etrade2db
# 192.168.19.51 elinkdb
# 20.205.243.166 github.com

# #SANDBOX DB
# # 192.168.19.31 etrade2db
# # 192.168.19.31 elinkdb

# # 192.168.8.243   test.elink.ph

# # 202.60.9.80 test.etrade.peza
# # 202.60.10.115 test.etrade.peza
# 202.60.10.115   test.etrade.peza
# # 192.168.43.174 test.etrade.peza
# 202.60.9.80 	test.etrade.net.ph


# # 202.60.10.115   test.etrade.peza
# 202.60.10.115   testpeza.etrade.net.ph
# # 202.60.10.115  uat-etradepeza.cdec.com.ph

# # 192.168.8.243  test.etrade.peza
# # 192.168.17.207 testpeza.etrade.net.ph


# # 192.168.17.175  prepaid01
# 192.168.19.164	prepaid01
# 192.168.19.163   walleturl
# # 202.60.10.132  walleturl
# 202.60.12.123   keycloak-dev.apolloglobal.net

# 127.0.0.1   	mail.smtp.auth

# EOF

# RUN adduser backupuser \ 
#     && mkdir /srv/maintenance \ 
#     && scp root@192.168.43.174:/srv/maintenance/* /srv/maintenance/

# RUN RUN echo "5 0 * * * /srv/maintenance/archivebee.sh" >> /etc/crontab && \
#     echo "5 1 * * * /srv/maintenance/copy_logs_xmlServer.sh" >> /etc/crontab && \
#     echo "5 2 * * * /srv/maintenance/move_logs_and_responses.sh" >> /etc/crontab && \
#     echo "* * * * * /var/lib/tomcat7/scripts/backend4_incoming_request.sh" >> /etc/crontab && \
#     echo "* * * * * /var/lib/tomcat7/scripts/backend_tomcat4_request.sh" >> /etc/crontab && \
#     echo "* * * * * /var/lib/tomcat7/scripts/upload_to_tosser4_request.sh" >> /etc/crontab && \
#     echo "* * * * * /var/lib/tomcat7/scripts/transfer_to_gofast_for_be4_request.sh" >> /etc/crontab && \
#     echo "* * * * * /var/lib/tomcat7/scripts/fedex_inbox_transfer_for_be4_request.sh" >> /etc/crontab && \
#     echo "* * * * * /var/lib/tomcat7/scripts/manifest_transfer_for_be4_request.sh" >> /etc/crontab && \
#     echo "* * * * * /var/lib/tomcat7/scripts/download_from_tosser_for_be4_request.sh" >> /etc/crontab && \
#     echo "* * * * * /var/lib/tomcat7/scripts/upload_to_cts_ams_for_be4_request.sh" >> /etc/crontab && \
#     echo "5 3 * * * /srv/maintenance/cdec_sl_copy.sh" >> /etc/crontab

# RUN mkdir /home/backupuser/e2m_uploaded \
#     && /home/backupuser/eips_processed \
#     && /home/backupuser/fedex_uploaded \
#     && /home/backupuser/ftp_logs \
#     && /home/backupuser/ftp_uploaded \
#     && /home/backupuser/eips_uploaded \
#     && /home/backupuser/responses \
#     && /home/backupuser/tomcat_logs

# RUN chown -R backupuser: /home/backupuser/e2m_uploaded \
#     && /home/backupuser/eips_processed \
#     && /home/backupuser/fedex_uploaded \
#     && /home/backupuser/ftp_logs \
#     && /home/backupuser/ftp_uploaded \
#     && /home/backupuser/eips_uploaded \
#     && /home/backupuser/responses \
#     && /home/backupuser/tomcat_logs

# RUN chmod -R 755 /home/backupuser/e2m_uploaded \
#     && /home/backupuser/eips_processed \
#     && /home/backupuser/fedex_uploaded \
#     && /home/backupuser/ftp_logs \
#     && /home/backupuser/ftp_uploaded \
#     && /home/backupuser/eips_uploaded \
#     && /home/backupuser/responses \
#     && /home/backupuser/tomcat_logs

# RUN mkdir -p /home/backupuser/.ssh && \
#     touch /home/backupuser/.ssh/authorized_keys && \
#     echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHY6TxU4BZUSUgYPzURUBnDejTtmcpQjPPgzZEQ98pjUXOvOYFu/fs9NJwDDPOG1iy9aauUhUn1sYT1ltQp1M8EyKa1dMsMS54WXGRW7vtOsuWFxJpdacEC6uF3Yn+KJre2nnYEyRi5tEJVBlZs1CGXCPBthT2/qOmOULnsLCWPNkhsAiHcrQlo14+yddJhcpbINLVSYfkMZNrEa0JcF3RDBa+vB0J181/pVHMvI3ep9/auETyncAUjP3TOM/v8I1wja098bDyF/LhF78J1UTaQSgIy1ysT8Bdef/9nsUOobCEU6kVT8QziLxcMu/Gq0s6vHAJfWsOkfhiNCAr348t root@etrade-fileserver.local" >> /home/backupuser/.ssh/authorized_keys

# RUN screen -dmS upload_to_tosser4 ./upload_to_tosser_agent.sh && \
#     screen -dmS transfer_to_gofast_for_be4 ./transfer_to_gofast_agent.sh && \
#     screen -dmS download_from_tosser_for_be4 ./download_from_tosser_for_be4_agent.sh && \
#     screen -dmS fedex_inbox_transfer_for_be4 ./fedex_inbox_transfer_agent.sh && \
#     screen -dmS manifest_transfer_for_be4 ./manifest_transfer_agent.sh && \
#     screen -dmS upload_to_cts_ams_for_be4 ./upload_to_cts_ams_agent.sh

# RUN  timedatectl set-timezone Asia/Manila

# RUN systemctl stop tomcat7

# RUN unzip /var/lib/tomcat7/war_for_deployment/test.etrade.be4.0.0.0.2.war -d /var/lib/tomcat7/webapps/etrade-2.0/ && \
#     rm /var/lib/tomcat7/webapps/etrade-2.0/WEB-INF/lib/commons-codec-1.3.jar

# RUN service tomcat7 start


# WORKDIR /etrade-2.0
# COPY . .
# RUN find . -name "*Zone.Identifier" -type f -delete

# COPY --from=deps /grails_plugins.1.3.7.tar.gz /etrade-2.0/grails_plugins.1.3.7.tar.gz
# COPY --from=deps /grails_plugins.1.3.7.rar /etrade-2.0/grails_plugins.1.3.7.rar

# RUN cp grails_plugins.1.3.7.rar "$HOME/.sdkman/candidates/grails/1.3.7/plugins/" \
#     && mkdir -p "$HOME/.grails/1.3.7/projects/etrade-2.0/plugins/" \
#     && cp grails_plugins.1.3.7.tar.gz "$HOME/.grails/1.3.7/projects/etrade-2.0/plugins/" \
#     && tar xvf "$HOME/.grails/1.3.7/projects/etrade-2.0/plugins/grails_plugins.1.3.7.tar.gz" -C "$HOME/.grails/1.3.7/projects/etrade-2.0/" \
#     && mv "$HOME/.grails/1.3.7/projects/etrade-2.0/grails_plugins.1.3.7/" "$HOME/.grails/1.3.7/projects/etrade-2.0/plugins/" \
#     && mv "$HOME/.grails/1.3.7/projects/etrade-2.0/plugins/grails_plugins.1.3.7/"* "$HOME/.grails/1.3.7/projects/etrade-2.0/plugins/" \
#     && mv "$HOME/.grails/1.3.7/projects/etrade-2.0/plugins/ws-client-1.0/ws-client-1.0/"* "$HOME/.grails/1.3.7/projects/etrade-2.0/plugins/ws-client-1.0/" \
#     && rm -r "$HOME/.grails/1.3.7/projects/etrade-2.0/plugins/ws-client-1.0/ws-client-1.0/" \
#     && rm /etrade-2.0/grails_plugins.1.3.7.tar.gz \
#     && rm /etrade-2.0/grails_plugins.1.3.7.rar
    
# WORKDIR /var/lib/tomcat7/logs
        
# RUN chown -R tomcat7:tomcat7 /var/lib/tomcat7/ && \
#     chown -R tomcat7:tomcat7 /var/lib/tomcat7/logs/

# RUN less catalina.out

# RUN tail -f etrade2.log



FROM python AS deps

RUN pip install gdown
RUN gdown https://drive.google.com/uc?id=1fqOwuOZNx3rCyAE3PMotoqkmYNzjythk
RUN gdown https://drive.google.com/uc?id=1xHiCgKUBgGizHPLxhONGr11tv4EUz_iA

FROM ubuntu:latest

ENV SDKMAN_DIR="/root/.sdkman"
ENV SDKMAN_INIT="$SDKMAN_DIR/bin/sdkman-init.sh"
ENV _JAVA_OPTIONS="-Xmx1024m"
ENV JAVA_OPTS="-Xmx2g -XX:MaxPermSize=1540m -Dstringchararrayaccessor.disabled=true"

RUN apt-get update -y \
    && apt-get -y install bash curl tar wget unzip zip unrar openssh-client \
    && rm /bin/sh \
    && ln -s /bin/bash /bin/sh \
    && curl -s "https://get.sdkman.io" | bash \
    && bash -c "source $SDKMAN_INIT && sdk install java 7.0.352-zulu && sdk install grails 1.3.7"

RUN cd /tmp/ \
    && curl -O https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.70/bin/apache-tomcat-7.0.70.tar.gz \
    && mkdir /var/lib/tomcat7/ \
    && tar xzvf apache-tomcat-7.0.70.tar.gz -C /var/lib/tomcat7 --strip-components=1

RUN groupadd tomcat7 \
    && useradd -s /bin/false -g tomcat7 -d /var/lib/tomcat7 tomcat7
	
RUN cd /var/lib/tomcat7 \
    && chgrp -R tomcat7 conf \
    && chmod g+rwx conf \
    && chmod g+r conf/* \
    && chown -R tomcat7 work/ temp/ logs/ 

RUN cat <<EOF > /etc/systemd/system/tomcat7.service
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/zulu7-ca-amd64/jre
Environment=CATALINA_PID=/var/lib/tomcat7/temp/tomcat.pid
Environment=CATALINA_HOME=/var/lib/tomcat7
Environment=CATALINA_BASE=/var/lib/tomcat7
Environment='CATALINA_OPTS=-Xmx7168M -Xms7168M -XX:PermSize=512m -XX:MaxPermSize=512m -XX:NewSize=256m -server -XX:+UseParallelGC'

ExecStart=/var/lib/tomcat7/bin/startup.sh
ExecStop=/var/lib/tomcat7/bin/shutdown.sh

User=tomcat7
Group=tomcat7
UMask=0007
RestartSec=10
Restart=always

WorkingDirectory=/var/lib/tomcat7


[Install]
WantedBy=multi-user.target
EOF

RUN touch /var/lib/tomcat7/stacktrace.log \
    && chown -R tomcat7:tomcat7 /var/lib/tomcat7/stacktrace.log

RUN mkdir /var/lib/tomcat7/acos_incoming_dir \
    /var/lib/tomcat7/acos_outgoing_dir \
    /var/lib/tomcat7/acos_unl_dir \
    /var/lib/tomcat7/ccbi_outgoing_dir \
    /var/lib/tomcat7/disabled_jobs_dir \
    /var/lib/tomcat7/e2m_af_incoming_dir \
    /var/lib/tomcat7/e2m_al_incoming_dir \
    /var/lib/tomcat7/e2m_incoming_dir \
    /var/lib/tomcat7/e2m_manifest_incoming_dir \
    /var/lib/tomcat7/e2m_olrs_incoming_dir \
    /var/lib/tomcat7/e2m_sf_incoming_dir \
    /var/lib/tomcat7/e2m_sl_incoming_dir \
    /var/lib/tomcat7/e2m_unl_dir \
    /var/lib/tomcat7/e2m_uploaded_dir \
    /var/lib/tomcat7/eips_incoming_dir \
    /var/lib/tomcat7/eips_outgoing_dir \
    /var/lib/tomcat7/email_xml_incoming_dir \
    /var/lib/tomcat7/fedex_uploaded \
    /var/lib/tomcat7/ftpscript \
    /var/lib/tomcat7/gofast_sl \
    /var/lib/tomcat7/manifest_port_outgoing_dir \
    /var/lib/tomcat7/Q2 \
    /var/lib/tomcat7/response_report_outgoing_dir \
    /var/lib/tomcat7/seed \
    /var/lib/tomcat7/temp_errorFolder \
    /var/lib/tomcat7/tempFolder \
    /var/lib/tomcat7/war_for_deployment \
    /var/lib/tomcat7/ftp_in \
    /var/lib/tomcat7/ftp_in/aspac\
    /var/lib/tomcat7/ftp_in/cathaypac \
    /var/lib/tomcat7/ftp_in/thaiair \
    /var/lib/tomcat7/ftp_in/yusena \
    /var/lib/tomcat7/acop_tp \
    /var/lib/tomcat7/aspac_uploaded \
    /var/lib/tomcat7/cbw_outgoing_dir \
    /var/lib/tomcat7/cdc_incoming_dir \
    /var/lib/tomcat7/cdc_outgoing_dir \
    /var/lib/tomcat7/cts_outgoing_dir \
    /var/lib/tomcat7/cts_temp_dir \
    /var/lib/tomcat7/cts_temp_outgoing_dir \
    /var/lib/tomcat7/e2m_abms_ledger_incoming_dir \
    /var/lib/tomcat7/e2m_callback_incoming_dir \
    /var/lib/tomcat7/e2m_outgoing_dir \
    /var/lib/tomcat7/egdvs_incoming_dir \
    /var/lib/tomcat7/eips_uploaded_dir \
    /var/lib/tomcat7/manifest_port5j_outgoing_dir \
    /var/lib/tomcat7/scripts \
    /var/lib/tomcat7/temp_af_incoming \
    /var/lib/tomcat7/temp_al_incoming \
    /var/lib/tomcat7/temp_errorFolder_tnt \
    /var/lib/tomcat7/temp_incoming \
    /var/lib/tomcat7/temp_reprocess \
    /var/lib/tomcat7/tempResponse \
    /var/lib/tomcat7/cts_sf_incoming_dir \
    /var/lib/tomcat7/cts_sl_incoming_dir \
    /var/lib/tomcat7/e2m_abms_temp_incoming \
    /var/lib/tomcat7/etrade_incoming_dir \
    /var/lib/tomcat7/etrade_outgoing_dir \
    /var/lib/tomcat7/etrade_uploaded_dir \
    /var/lib/tomcat7/peza_ed_outgoing_dir \
    /var/lib/tomcat7/peza_ed_uploaded_dir \
    /var/lib/tomcat7/peza_outgoing_dir \
    /var/lib/tomcat7/peza_uploaded_dir


RUN chown -R tomcat7: /var/lib/tomcat7/acos_incoming_dir \
    /var/lib/tomcat7/acos_outgoing_dir \
    /var/lib/tomcat7/acos_unl_dir \
    /var/lib/tomcat7/ccbi_outgoing_dir \
    /var/lib/tomcat7/disabled_jobs_dir \
    /var/lib/tomcat7/e2m_af_incoming_dir \
    /var/lib/tomcat7/e2m_al_incoming_dir \
    /var/lib/tomcat7/e2m_incoming_dir \
    /var/lib/tomcat7/e2m_manifest_incoming_dir \
    /var/lib/tomcat7/e2m_olrs_incoming_dir \
    /var/lib/tomcat7/e2m_sf_incoming_dir \
    /var/lib/tomcat7/e2m_sl_incoming_dir \
    /var/lib/tomcat7/e2m_unl_dir \
    /var/lib/tomcat7/e2m_uploaded_dir \
    /var/lib/tomcat7/eips_incoming_dir \
    /var/lib/tomcat7/eips_outgoing_dir \
    /var/lib/tomcat7/email_xml_incoming_dir \
    /var/lib/tomcat7/fedex_uploaded \
    /var/lib/tomcat7/ftpscript \
    /var/lib/tomcat7/gofast_sl \
    /var/lib/tomcat7/manifest_port_outgoing_dir \
    /var/lib/tomcat7/Q2 \
    /var/lib/tomcat7/response_report_outgoing_dir \
    /var/lib/tomcat7/seed \
    /var/lib/tomcat7/temp_errorFolder \
    /var/lib/tomcat7/tempFolder \
    /var/lib/tomcat7/war_for_deployment \
    /var/lib/tomcat7/ftp_in \
    /var/lib/tomcat7/ftp_in/aspac \
    /var/lib/tomcat7/ftp_in/cathaypac \
    /var/lib/tomcat7/ftp_in/thaiair \
    /var/lib/tomcat7/ftp_in/yusena \
    /var/lib/tomcat7/acop_tp \
    /var/lib/tomcat7/aspac_uploaded \
    /var/lib/tomcat7/cbw_outgoing_dir \
    /var/lib/tomcat7/cdc_incoming_dir \
    /var/lib/tomcat7/cdc_outgoing_dir \
    /var/lib/tomcat7/cts_outgoing_dir \
    /var/lib/tomcat7/cts_temp_dir \
    /var/lib/tomcat7/cts_temp_outgoing_dir \
    /var/lib/tomcat7/e2m_abms_ledger_incoming_dir \
    /var/lib/tomcat7/e2m_callback_incoming_dir \
    /var/lib/tomcat7/e2m_outgoing_dir \
    /var/lib/tomcat7/egdvs_incoming_dir \
    /var/lib/tomcat7/eips_uploaded_dir \
    /var/lib/tomcat7/manifest_port5j_outgoing_dir \
    /var/lib/tomcat7/scripts \
    /var/lib/tomcat7/temp_af_incoming \
    /var/lib/tomcat7/temp_al_incoming \
    /var/lib/tomcat7/temp_errorFolder_tnt \
    /var/lib/tomcat7/temp_incoming \
    /var/lib/tomcat7/temp_reprocess \
    /var/lib/tomcat7/tempResponse \
    /var/lib/tomcat7/cts_sf_incoming_dir \
    /var/lib/tomcat7/cts_sl_incoming_dir \
    /var/lib/tomcat7/e2m_abms_temp_incoming \
    /var/lib/tomcat7/etrade_incoming_dir \
    /var/lib/tomcat7/etrade_outgoing_dir \
    /var/lib/tomcat7/etrade_uploaded_dir \
    /var/lib/tomcat7/peza_ed_outgoing_dir \
    /var/lib/tomcat7/peza_ed_uploaded_dir \
    /var/lib/tomcat7/peza_outgoing_dir \
    /var/lib/tomcat7/peza_uploaded_dir

RUN chmod -R 755 /var/lib/tomcat7/acos_incoming_dir \
    /var/lib/tomcat7/acos_outgoing_dir \
    /var/lib/tomcat7/acos_unl_dir \
    /var/lib/tomcat7/ccbi_outgoing_dir \
    /var/lib/tomcat7/e2m_af_incoming_dir \
    /var/lib/tomcat7/e2m_al_incoming_dir \
    /var/lib/tomcat7/e2m_incoming_dir \
    /var/lib/tomcat7/e2m_manifest_incoming_dir \
    /var/lib/tomcat7/e2m_olrs_incoming_dir \
    /var/lib/tomcat7/e2m_sf_incoming_dir \
    /var/lib/tomcat7/e2m_sl_incoming_dir \
    /var/lib/tomcat7/e2m_unl_dir \
    /var/lib/tomcat7/e2m_uploaded_dir \
    /var/lib/tomcat7/eips_incoming_dir \
    /var/lib/tomcat7/eips_outgoing_dir \
    /var/lib/tomcat7/email_xml_incoming_dir \
    /var/lib/tomcat7/gofast_sl \
    /var/lib/tomcat7/manifest_port_outgoing_dir \
    /var/lib/tomcat7/response_report_outgoing_dir \
    /var/lib/tomcat7/seed \
    /var/lib/tomcat7/acop_tp \
    /var/lib/tomcat7/aspac_uploaded \
    /var/lib/tomcat7/cbw_outgoing_dir \
    /var/lib/tomcat7/cdc_incoming_dir \
    /var/lib/tomcat7/cdc_outgoing_dir \
    /var/lib/tomcat7/cts_outgoing_dir \
    /var/lib/tomcat7/cts_temp_dir \
    /var/lib/tomcat7/cts_temp_outgoing_dir \
    /var/lib/tomcat7/e2m_callback_incoming_dir \
    /var/lib/tomcat7/e2m_outgoing_dir \
    /var/lib/tomcat7/egdvs_incoming_dir \
    /var/lib/tomcat7/eips_uploaded_dir \
    /var/lib/tomcat7/manifest_port5j_outgoing_dir \
    /var/lib/tomcat7/scripts \
    /var/lib/tomcat7/temp_af_incoming \
    /var/lib/tomcat7/temp_al_incoming \
    /var/lib/tomcat7/temp_errorFolder_tnt \
    /var/lib/tomcat7/temp_incoming \
    /var/lib/tomcat7/temp_reprocess \
    /var/lib/tomcat7/tempResponse \
    /var/lib/tomcat7/cts_sf_incoming_dir \
    /var/lib/tomcat7/cts_sl_incoming_dir \
    /var/lib/tomcat7/e2m_abms_temp_incoming \
    /var/lib/tomcat7/peza_outgoing_dir \
    /var/lib/tomcat7/peza_uploaded_dir

RUN chmod -R 777 \
    /var/lib/tomcat7/disabled_jobs_dir \
    /var/lib/tomcat7/fedex_uploaded \
    /var/lib/tomcat7/ftpscript \
    /var/lib/tomcat7/Q2 \
    /var/lib/tomcat7/temp_errorFolder \
    /var/lib/tomcat7/tempFolder \
    /var/lib/tomcat7/war_for_deployment \
    /var/lib/tomcat7/ftp_in \
    /var/lib/tomcat7/ftp_in/aspac \
    /var/lib/tomcat7/ftp_in/cathaypac \
    /var/lib/tomcat7/ftp_in/thaiair \
    /var/lib/tomcat7/ftp_in/yusena \
    /var/lib/tomcat7/e2m_abms_ledger_incoming_dir \
    /var/lib/tomcat7/etrade_incoming_dir \
    /var/lib/tomcat7/etrade_outgoing_dir \
    /var/lib/tomcat7/etrade_uploaded_dir \
    /var/lib/tomcat7/peza_ed_outgoing_dir \
    /var/lib/tomcat7/peza_ed_uploaded_dir

RUN touch /var/lib/tomcat7/disabled_jobs_dir/AbmsLedgerProcessing.disableNOT && \
    touch /var/lib/tomcat7/disabled_jobs_dir/AcosResponseProcessing.disable && \
    touch /var/lib/tomcat7/disabled_jobs_dir/AcosUnlProcessing.disable && \
    touch /var/lib/tomcat7/disabled_jobs_dir/AirlineManifestResponseProcessing.disable && \
    touch /var/lib/tomcat7/disabled_jobs_dir/AirManifestAutoSending.disable && \
    touch /var/lib/tomcat7/disabled_jobs_dir/AirManifestResponseProcessing.disable && \
    touch /var/lib/tomcat7/disabled_jobs_dir/AirManifestSchedulerProcessing.disable && \
    touch /var/lib/tomcat7/disabled_jobs_dir/AutomatedCusdecProccessing.disable && \
    touch /var/lib/tomcat7/disabled_jobs_dir/CallbackProcessing.disable && \
    touch /var/lib/tomcat7/disabled_jobs_dir/CCBICusdecForwarding.disable && \
    touch /var/lib/tomcat7/disabled_jobs_dir/CloudProcessing.disable && \
    touch /var/lib/tomcat7/disabled_jobs_dir/CountTransaction.disable && \
    touch /var/lib/tomcat7/disabled_jobs_dir/CprsProcessing.disable && \
    touch /var/lib/tomcat7/disabled_jobs_dir/E2mResponseProcessing.disable && \
    touch /var/lib/tomcat7/disabled_jobs_dir/E2mUnlProcessing.disable && \
    touch /var/lib/tomcat7/disabled_jobs_dir/EgdvsProcessing.disable && \
    touch /var/lib/tomcat7/disabled_jobs_dir/EipsProcessing.disable && \
    touch /var/lib/tomcat7/disabled_jobs_dir/EmailXmlProcessing.disableNOT && \
    touch /var/lib/tomcat7/disabled_jobs_dir/InformalEntryProcessing.disable && \
    touch /var/lib/tomcat7/disabled_jobs_dir/ManifestResponseProcessing.disable && \
    touch /var/lib/tomcat7/disabled_jobs_dir/OlrsProcessing.disable && \
    touch /var/lib/tomcat7/disabled_jobs_dir/PezaStatusUpdateProcessing.disable && \
    touch /var/lib/tomcat7/disabled_jobs_dir/SeaManifestResponseProcessing.disableNOT && \
    touch /var/lib/tomcat7/disabled_jobs_dir/SftpProcessing.disable && \
    touch /var/lib/tomcat7/disabled_jobs_dir/ShippinglineManifestResponseProcessing.disableNOT

RUN chmod -R 744 /var/lib/tomcat7/disabled_jobs_dir
	
RUN chown -R tomcat7: /var/lib/tomcat7/disabled_jobs_dir

RUN mkdir /var/tmp/e2m \
    /var/tmp/e2m/bol /var/tmp/e2m/cusdec \
    /var/tmp/e2m/manifest \
    /var/tmp/e2m/olrs \
    /var/tmp/e2m/transit_permit
	
RUN chown -R tomcat7: /var/tmp/e2m \
    /var/tmp/e2m/bol \
    /var/tmp/e2m/cusdec \
    /var/tmp/e2m/manifest \
    /var/tmp/e2m/olrs \
    /var/tmp/e2m/transit_permit
	
RUN chmod -R 755 /var/tmp/e2m \
    /var/tmp/e2m/bol \
    /var/tmp/e2m/cusdec \
    /var/tmp/e2m/manifest \
    /var/tmp/e2m/olrs \
    /var/tmp/e2m/transit_permit

WORKDIR /

RUN mkdir -p /root/.ssh && \
    touch /root/.ssh/id_rsa.pub

RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDjuucNgIDT2nsAABNN63HmlGNqZg6QQNiSHK40U58+oAK69WG18TCf1Af3Rhz2nkXTY66iPd8dKbyLb/74mcGnKEOQIdrQ4YEAlXLxN9e/tP1/2BCNaSFhIt69EFBfM5ku1qEjvhIQOHp867OVuOadUZYliqGd3SqjPEYAVK2YQ8e03+50E7vEZrgnkyslsuJQtuvZOaeJUJri3/1RJlJd8lVKN1FjmnKNs1aGQIElQ5RC/xbZxbXPghYWIwoHBFEDexhuGwRfrQLSpX8REQlPx4mYtOf0jS6GqUmu3OvPBeZfXkpAX+F/exIGrHNt9hUQH3wTs3OdfjnGI84Msple5NZikm33maUpDopbzPSuseXko5eiucrj+g6xbUvWUPUGmS6/OqdGi7eLLAWO9XK8Q02ozPmAaLvSzoCMHpHk/xepaR77uifUREtcv7Z2fSfEDDNgQ9N8qSiZwOtruELZt/bqUSgOTokC+ncDZv20ofnvZX8UKa/PVMtiU4vM0ws= root@LAPTOP-7EUI03CP" > /root/.ssh/id_rsa.pub

RUN scp root@192.168.43.174:/var/lib/tomcat7/war_for_deployment/* /var/lib/tomcat7/war_for_deployment \
    && scp root@192.168.43.174:/var/lib/tomcat7/ftpscript/*.sh /var/lib/tomcat7/ftpscript/ \
    && scp root@192.168.43.174:/var/lib/tomcat7/scripts/*.sh /var/lib/tomcat7/scripts/ \
    && scp root@192.168.43.174:/var/lib/tomcat7/ftpscript/xml.keystore /var/lib/tomcat7/ftpscript/ \
    && scp root@192.168.43.174:/var/www/html/dtd/* /var/www/html/dtd/

RUN cat <<EOF > /etc/hosts
192.168.43.174   strategyobject.com

#PENTAHO DB
192.168.19.51   etrade2db
192.168.19.51 elinkdb
20.205.243.166 github.com

#SANDBOX DB
# 192.168.19.31 etrade2db
# 192.168.19.31 elinkdb

# 192.168.8.243   test.elink.ph

# 202.60.9.80 test.etrade.peza
# 202.60.10.115 test.etrade.peza
202.60.10.115   test.etrade.peza
# 192.168.43.174 test.etrade.peza
202.60.9.80 	test.etrade.net.ph


# 202.60.10.115   test.etrade.peza
202.60.10.115   testpeza.etrade.net.ph
# 202.60.10.115  uat-etradepeza.cdec.com.ph

# 192.168.8.243  test.etrade.peza
# 192.168.17.207 testpeza.etrade.net.ph


# 192.168.17.175  prepaid01
192.168.19.164	prepaid01
192.168.19.163   walleturl
# 202.60.10.132  walleturl
202.60.12.123   keycloak-dev.apolloglobal.net

127.0.0.1   	mail.smtp.auth

EOF

WORKDIR /

RUN adduser backupuser \ 
    && mkdir /srv/maintenance \ 
    && scp root@192.168.43.174:/srv/maintenance/* /srv/maintenance/

RUN RUN echo "5 0 * * * /srv/maintenance/archivebee.sh" >> /etc/crontab && \
    echo "5 1 * * * /srv/maintenance/copy_logs_xmlServer.sh" >> /etc/crontab && \
    echo "5 2 * * * /srv/maintenance/move_logs_and_responses.sh" >> /etc/crontab && \
    echo "* * * * * /var/lib/tomcat7/scripts/backend4_incoming_request.sh" >> /etc/crontab && \
    echo "* * * * * /var/lib/tomcat7/scripts/backend_tomcat4_request.sh" >> /etc/crontab && \
    echo "* * * * * /var/lib/tomcat7/scripts/upload_to_tosser4_request.sh" >> /etc/crontab && \
    echo "* * * * * /var/lib/tomcat7/scripts/transfer_to_gofast_for_be4_request.sh" >> /etc/crontab && \
    echo "* * * * * /var/lib/tomcat7/scripts/fedex_inbox_transfer_for_be4_request.sh" >> /etc/crontab && \
    echo "* * * * * /var/lib/tomcat7/scripts/manifest_transfer_for_be4_request.sh" >> /etc/crontab && \
    echo "* * * * * /var/lib/tomcat7/scripts/download_from_tosser_for_be4_request.sh" >> /etc/crontab && \
    echo "* * * * * /var/lib/tomcat7/scripts/upload_to_cts_ams_for_be4_request.sh" >> /etc/crontab && \
    echo "5 3 * * * /srv/maintenance/cdec_sl_copy.sh" >> /etc/crontab

RUN mkdir /home/backupuser/e2m_uploaded \
    && /home/backupuser/eips_processed \
    && /home/backupuser/fedex_uploaded \
    && /home/backupuser/ftp_logs \
    && /home/backupuser/ftp_uploaded \
    && /home/backupuser/eips_uploaded \
    && /home/backupuser/responses \
    && /home/backupuser/tomcat_logs

RUN chown -R backupuser: /home/backupuser/e2m_uploaded \
    && /home/backupuser/eips_processed \
    && /home/backupuser/fedex_uploaded \
    && /home/backupuser/ftp_logs \
    && /home/backupuser/ftp_uploaded \
    && /home/backupuser/eips_uploaded \
    && /home/backupuser/responses \
    && /home/backupuser/tomcat_logs

RUN chmod -R 755 /home/backupuser/e2m_uploaded \
    && /home/backupuser/eips_processed \
    && /home/backupuser/fedex_uploaded \
    && /home/backupuser/ftp_logs \
    && /home/backupuser/ftp_uploaded \
    && /home/backupuser/eips_uploaded \
    && /home/backupuser/responses \
    && /home/backupuser/tomcat_logs

RUN mkdir -p /home/backupuser/.ssh && \
    touch /home/backupuser/.ssh/authorized_keys && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHY6TxU4BZUSUgYPzURUBnDejTtmcpQjPPgzZEQ98pjUXOvOYFu/fs9NJwDDPOG1iy9aauUhUn1sYT1ltQp1M8EyKa1dMsMS54WXGRW7vtOsuWFxJpdacEC6uF3Yn+KJre2nnYEyRi5tEJVBlZs1CGXCPBthT2/qOmOULnsLCWPNkhsAiHcrQlo14+yddJhcpbINLVSYfkMZNrEa0JcF3RDBa+vB0J181/pVHMvI3ep9/auETyncAUjP3TOM/v8I1wja098bDyF/LhF78J1UTaQSgIy1ysT8Bdef/9nsUOobCEU6kVT8QziLxcMu/Gq0s6vHAJfWsOkfhiNCAr348t root@etrade-fileserver.local" >> /home/backupuser/.ssh/authorized_keys

RUN screen -dmS upload_to_tosser4 ./upload_to_tosser_agent.sh && \
    screen -dmS transfer_to_gofast_for_be4 ./transfer_to_gofast_agent.sh && \
    screen -dmS download_from_tosser_for_be4 ./download_from_tosser_for_be4_agent.sh && \
    screen -dmS fedex_inbox_transfer_for_be4 ./fedex_inbox_transfer_agent.sh && \
    screen -dmS manifest_transfer_for_be4 ./manifest_transfer_agent.sh && \
    screen -dmS upload_to_cts_ams_for_be4 ./upload_to_cts_ams_agent.sh

RUN timedatectl set-timezone Asia/Manila

RUN unzip /var/lib/tomcat7/war_for_deployment/test.etrade.be4.0.0.0.2.war -d /var/lib/tomcat7/webapps/etrade-2.0/ && \
    rm /var/lib/tomcat7/webapps/etrade-2.0/WEB-INF/lib/commons-codec-1.3.jar

RUN service tomcat7 start


WORKDIR /etrade-2.0
COPY . .
RUN find . -name "*Zone.Identifier" -type f -delete

COPY --from=deps /grails_plugins.1.3.7.tar.gz /etrade-2.0/grails_plugins.1.3.7.tar.gz
COPY --from=deps /grails_plugins.1.3.7.rar /etrade-2.0/grails_plugins.1.3.7.rar

RUN cp grails_plugins.1.3.7.rar "$HOME/.sdkman/candidates/grails/1.3.7/plugins/" \
    && mkdir -p "$HOME/.grails/1.3.7/projects/etrade-2.0/plugins/" \
    && cp grails_plugins.1.3.7.tar.gz "$HOME/.grails/1.3.7/projects/etrade-2.0/plugins/" \
    && tar xvf "$HOME/.grails/1.3.7/projects/etrade-2.0/plugins/grails_plugins.1.3.7.tar.gz" -C "$HOME/.grails/1.3.7/projects/etrade-2.0/" \
    && mv "$HOME/.grails/1.3.7/projects/etrade-2.0/grails_plugins.1.3.7/" "$HOME/.grails/1.3.7/projects/etrade-2.0/plugins/" \
    && mv "$HOME/.grails/1.3.7/projects/etrade-2.0/plugins/grails_plugins.1.3.7/"* "$HOME/.grails/1.3.7/projects/etrade-2.0/plugins/" \
    && mv "$HOME/.grails/1.3.7/projects/etrade-2.0/plugins/ws-client-1.0/ws-client-1.0/"* "$HOME/.grails/1.3.7/projects/etrade-2.0/plugins/ws-client-1.0/" \
    && rm -r "$HOME/.grails/1.3.7/projects/etrade-2.0/plugins/ws-client-1.0/ws-client-1.0/" \
    && rm /etrade-2.0/grails_plugins.1.3.7.tar.gz \
    && rm /etrade-2.0/grails_plugins.1.3.7.rar
    
WORKDIR /var/lib/tomcat7/logs
        
RUN chown -R tomcat7:tomcat7 /var/lib/tomcat7/ && \
    chown -R tomcat7:tomcat7 /var/lib/tomcat7/logs/

RUN less catalina.out

RUN tail -f etrade2.log