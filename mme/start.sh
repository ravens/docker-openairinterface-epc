#!/bin/bash
# MME Configuration
sed -i s/"mme.openair4G.eur"/$MME_CN_NAME/g /usr/local/etc/oai/mme.conf
sed -i s/"yang.openair4G.eur"/$MME_CN_NAME/g /usr/local/etc/oai/freeDiameter/mme_fd.conf
sed -i s/"mme.openair4G.eur"/$MME_CN_NAME/g /usr/local/etc/oai/freeDiameter/mme_fd.conf
sed -i s/"hss.openair4G.eur"/$HSS_CN_NAME/g /usr/local/etc/oai/freeDiameter/mme_fd.conf

# set IP addr
sed -i s/"192.168.11.17"/"$MME_IPV4_ADDRESS_FOR_S1_MME"/g /usr/local/etc/oai/mme.conf
sed -i s/"127.0.0.1"/"$HSS_IPV4_ADDRESS"/g /usr/local/etc/oai/freeDiameter/mme_fd.conf


# Generation of certificate for diameter
cd /root
if [[ ! -d /root/demoCA ]];then
  mkdir demoCA && touch demoCA/index.txt && echo 01 > demoCA/serial
  openssl req  -new -batch -x509 -days 3650 -nodes -newkey rsa:1024 -out mme.cacert.pem -keyout mme.cakey.pem -subj /CN=$MME_CN_NAME/C=FR/ST=PACA/L=Aix/O=Eurecom/OU=CM
  openssl genrsa -out mme.key.pem 1024
  openssl req -new -batch -out mme.csr.pem -key mme.key.pem -subj /CN=$MME_CN_NAME/C=FR/ST=PACA/L=Aix/O=Eurecom/OU=CM
  openssl ca -cert mme.cacert.pem -keyfile mme.cakey.pem -in mme.csr.pem -out mme.cert.pem -outdir . -batch
  mv /root/mme.cakey.pem /usr/local/etc/oai/freeDiameter/
  mv /root/mme.cert.pem /usr/local/etc/oai/freeDiameter/
  mv /root/mme.cacert.pem /usr/local/etc/oai/freeDiameter/
  mv /root/mme.key.pem /usr/local/etc/oai/freeDiameter/
fi
# Start mme
sleep 17 && /root/openair-cn/build/mme/build/mme
