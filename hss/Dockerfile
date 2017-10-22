FROM ubuntu:16.04
MAINTAINER Yan Grunenberger <yan@grunenberger.net>

### dependencies and downloads

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -yq dist-upgrade 

# General utilities
RUN apt-get -qy install git wget apt-utils autoconf  \
 automake  \
 bison     \
 build-essential \
 cmake \
 cmake-curses-gui  \
 doxygen \
 doxygen-gui\
 debhelper \
 flex  \
 gdb \
 pkg-config \
 subversion \
 libconfig8-dev \
 libgcrypt-dev \
 libidn2-0-dev \
 libpq-dev \
 libidn11-dev \
 libmysqlclient-dev \
 libpthread-stubs0-dev \
 libsctp1 \
 libsctp-dev \
 libxml2-dev \
 libssl-dev \
 libtool \
 libgmp-dev \
 libtasn1-6-dev \     
 libp11-kit-dev \
 libtspi-dev \
 libtspi1 \
 libidn2-0-dev \
 libidn11-dev \
 openssl \
 mercurial \
 python-dev \
 ssl-cert \
 swig 


WORKDIR /root
RUN wget https://ftp.gnu.org/gnu/nettle/nettle-2.5.tar.gz 
RUN tar -xzf nettle-2.5.tar.gz

WORKDIR /root
RUN wget http://mirrors.dotsrc.org/gcrypt/gnutls/v3.1/gnutls-3.1.23.tar.xz
RUN tar -xJf gnutls-3.1.23.tar.xz

WORKDIR /root
RUN git clone https://gitlab.eurecom.fr/oai/freediameter.git -b eurecom-1.2.0  

# other mirror : ftp://ftp.lysator.liu.se/pub/security/lsh/nettle-2.5.tar.gz
WORKDIR /root
RUN cd nettle-2.5/ &&  ./configure --disable-openssl --enable-shared --prefix=/usr  &&  make -j`nproc` &&  make check  &&  make install 

WORKDIR /root
RUN cd gnutls-3.1.23/ &&  ./configure --prefix=/usr && make -j`nproc` && make install

# Run freediameter (hard dependencies on gnutls)
WORKDIR /root/freediameter
RUN mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr ../ && make -j`nproc` && make install 

# cloning directory
WORKDIR /root
RUN git clone https://gitlab.eurecom.fr/oai/openair-cn.git 

####################### START OF CUSTOMIZATION

#### CUSTOMIZE YOUR DATABASE PARAMETERS  
ARG MYSQLHOSTNAME=db.openair4G.eur
ARG MYSQLUSER=root
ARG MYSQLPASSWORD=linux
ARG MYSQLDATABASE=oai_db

#### CUSTOMIZE YOUR BUILD PARAMETER
ARG OAIBRANCH=develop

#### CUSTOMIZE YOUR OPERATOR KEY 
ARG OPKEY=63bfa50ee6523365ff14c1f45f88737d

#### CUSTOMIZE YOUR HSS HOSTNAME (used in certificates)
ARG HSS_CN_NAME=hss.openair4G.eur

####################### END OF CUSTOMIZATION

# cloning directory
WORKDIR /root/openair-cn
RUN git checkout $OAIBRANCH

#  install_asn1c_from_source
#WORKDIR /root
#RUN apt-get -qy install autoconf automake bison build-essential flex gcc libtool
#RUN git clone https://gitlab.eurecom.fr/oai/asn1c.git 
#RUN cd asn1c && ./configure && make && make install

# compiling OAI HSS executable oai_hss
WORKDIR /root/openair-cn/build/hss
RUN mkdir build
WORKDIR /root/openair-cn/build/hss/build
RUN cmake -DOPENAIRCN_DIR=/root/openair-cn ../
RUN make -j`nproc`

RUN mkdir -p /usr/local/etc/oai/freeDiameter
RUN cp /root/openair-cn/etc/hss.conf /usr/local/etc/oai/
RUN cp /root/openair-cn/etc/hss_fd.conf /usr/local/etc/oai/freeDiameter/
RUN cp /root/openair-cn/etc/acl.conf /usr/local/etc/oai/freeDiameter/

# MySQL database configuration 
RUN sed -i "s/@MYSQL_user@/$MYSQLUSER/g" /usr/local/etc/oai/hss.conf
RUN sed -i "s/@MYSQL_pass@/$MYSQLPASSWORD/g" /usr/local/etc/oai/hss.conf
RUN sed -i "s/127.0.0.1/$MYSQLHOSTNAME/g" /usr/local/etc/oai/hss.conf
RUN sed -i "s/oai_db/$MYSQLDATABASE/g" /usr/local/etc/oai/hss.conf

# Operator key (OP)
RUN sed -i "s/1006020f0a478bf6b699f15c062e42b3/$OPKEY/g" /usr/local/etc/oai/hss.conf

# Generation of certificate for diameter 
WORKDIR /root/
RUN mkdir demoCA && touch demoCA/index.txt && echo 01 > demoCA/serial
RUN openssl req  -new -batch -x509 -days 3650 -nodes -newkey rsa:1024 -out hss.cacert.pem -keyout hss.cakey.pem -subj /CN=$HSS_CN_NAME/C=FR/ST=PACA/L=Aix/O=Eurecom/OU=CM
RUN openssl genrsa -out hss.key.pem 1024
RUN openssl req -new -batch -out hss.csr.pem -key hss.key.pem -subj /CN=$HSS_CN_NAME/C=FR/ST=PACA/L=Aix/O=Eurecom/OU=CM
RUN openssl ca -cert hss.cacert.pem -keyfile hss.cakey.pem -in hss.csr.pem -out hss.cert.pem -outdir . -batch
RUN mv hss.cakey.pem hss.cert.pem hss.cacert.pem hss.key.pem /usr/local/etc/oai/freeDiameter/

#ready to work
WORKDIR /root
ENTRYPOINT bash -x -c "sleep 15 && /root/openair-cn/build/hss/build/oai_hss"