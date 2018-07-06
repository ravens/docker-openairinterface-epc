#!/bin/bash
# MySQL database configuration
sed -i "s/@MYSQL_user@/$MYSQLUSER/g" /usr/local/etc/oai/hss.conf
sed -i "s/@MYSQL_pass@/$MYSQLPASSWORD/g" /usr/local/etc/oai/hss.conf
sed -i "s/127.0.0.1/$MYSQLHOSTNAME/g" /usr/local/etc/oai/hss.conf
sed -i "s/oai_db/$MYSQLDATABASE/g" /usr/local/etc/oai/hss.conf
sed -i "s/db.openair4G.eur/$MYSQLHOSTNAME/g" /usr/local/etc/oai/hss.conf

# Operator key (OP)
sed -i "s/1006020f0a478bf6b699f15c062e42b3/$OPKEY/g" /usr/local/etc/oai/hss.conf

# HSS Configuration
sed -i "s/hss.openair4G.eur/$HSS_CN_NAME/g" /usr/local/etc/oai/hss.conf
sed -i "s/hss.openair4G.eur/$HSS_CN_NAME/g" /usr/local/etc/oai/freeDiameter/hss_fd.conf
sed -i "s/hss.openair4G.eur/$HSS_CN_NAME/g" /usr/local/etc/oai/freeDiameter/acl.conf

# Generation of certificate for diameter
cd /root
if [[ ! -d /root/demoCA ]];then
	mkdir demoCA && touch demoCA/index.txt && echo 01 > demoCA/serial
	openssl req  -new -batch -x509 -days 3650 -nodes -newkey rsa:1024 -out hss.cacert.pem -keyout hss.cakey.pem -subj /CN=$HSS_CN_NAME/C=FR/ST=PACA/L=Aix/O=Eurecom/OU=CM
	openssl genrsa -out hss.key.pem 1024
	openssl req -new -batch -out hss.csr.pem -key hss.key.pem -subj /CN=$HSS_CN_NAME/C=FR/ST=PACA/L=Aix/O=Eurecom/OU=CM
	openssl ca -cert hss.cacert.pem -keyfile hss.cakey.pem -in hss.csr.pem -out hss.cert.pem -outdir . -batch
	mv /root/hss.cakey.pem /usr/local/etc/oai/freeDiameter/
	mv /root/hss.cert.pem /usr/local/etc/oai/freeDiameter/
	mv /root/hss.cacert.pem /usr/local/etc/oai/freeDiameter/
	mv /root/hss.key.pem /usr/local/etc/oai/freeDiameter/
fi

# Start hss
sleep 15 && /root/openair-cn/build/hss/build/oai_hss
