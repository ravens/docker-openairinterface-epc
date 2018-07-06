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
# RUN cp /root/openair-cn/etc/hss.conf /usr/local/etc/oai/
RUN cp /root/openair-cn/etc/hss_fd.conf /usr/local/etc/oai/freeDiameter/
RUN cp /root/openair-cn/etc/acl.conf /usr/local/etc/oai/freeDiameter/

ENV MYSQLUSER=root
ENV MYSQLPASSWORD=linux
ENV MYSQLDATABASE=oai_db
ENV MYSQLHOSTNAME=db.openair4G.eur


ENV OPKEY=63bfa50ee6523365ff14c1f45f88737d

ENV HSS_CN_NAME=hss.openair4G.eur
#ready to work
WORKDIR /root
COPY start.sh /root/start.sh
RUN chmod +x /root/start.sh
ENTRYPOINT "/root/start.sh"

