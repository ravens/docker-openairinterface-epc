FROM ubuntu:16.04
MAINTAINER Yan Grunenberger <yan@grunenberger.net>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -yq dist-upgrade 

# General utilities
RUN apt-get -qy install git wget apt-utils

# cloning directory
WORKDIR /root
RUN git clone https://gitlab.eurecom.fr/oai/openair-cn.git 

WORKDIR /root/openair-cn
RUN git checkout develop

WORKDIR /root

# Fixing default mysql root password to "linux". This is the default assumed by OAI building scripts
RUN echo 'mysql-server mysql-server/root_password password linux' | debconf-set-selections
RUN echo 'mysql-server mysql-server/root_password_again password linux' | debconf-set-selections
RUN echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
RUN echo 'phpmyadmin phpmyadmin/app-password-confirm password linux ' | debconf-set-selections
RUN echo 'phpmyadmin phpmyadmin/mysql/admin-pass password linux' | debconf-set-selections
RUN echo 'phpmyadmin phpmyadmin/mysql/app-pass password linux' | debconf-set-selections
RUN echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections

# (Build script - MME dependencies...)
# (from build_helper) Remove incompatible softwares
RUN apt-get -qy --purge remove  libgnutls-dev  \
 'libgnutlsxx2?'  \
 nettle-dev  \
 nettle-bin

# (from build_helper) Compilers, Generators
RUN apt-get -qy install autoconf  \
 automake  \
 bison     \
 build-essential \
 cmake \
 cmake-curses-gui  \
 doxygen \
 doxygen-gui\
 flex  \
 gdb \
 pkg-config 

# (from build_helper) git/svn
RUN apt-get -qy install git \
 subversion

# (from build_helper) librairies
RUN apt-get -qy install libconfig8-dev \
 libgcrypt11-dev \
 libidn2-0-dev \
 libidn11-dev \
 libmysqlclient-dev \
 libpthread-stubs0-dev \
 libsctp1 \
 libsctp-dev \
 libssl-dev \
 libtool \
 mysql-client \
 mysql-server \
 openssl 

# (from build_helper) compile nettle from source
RUN apt-get -qy install  \
 autoconf  \
 automake  \
 build-essential \
 libgmp-dev
WORKDIR /root
# other mirror : ftp://ftp.lysator.liu.se/pub/security/lsh/nettle-2.5.tar.gz
RUN wget https://ftp.gnu.org/gnu/nettle/nettle-2.5.tar.gz 
RUN tar -xzf nettle-2.5.tar.gz
RUN cd nettle-2.5/ &&  ./configure --disable-openssl --enable-shared --prefix=/usr  &&  make -j`nproc` &&  make check  &&  make install 

# (from build_helper) install_gnutls_from_source $1
WORKDIR /root
RUN apt-get -qy install \
 autoconf  \
 automake  \
 build-essential
#      libtasn1-6-dbg \  libp11-kit0-dbg \
RUN apt-get -qy install libtasn1-6-dev \     
 libp11-kit-dev \
 libtspi-dev \
 libtspi1 \
 libidn2-0-dev \
 libidn11-dev
RUN wget http://mirrors.dotsrc.org/gcrypt/gnutls/v3.1/gnutls-3.1.23.tar.xz
RUN tar -xJf gnutls-3.1.23.tar.xz
RUN cd gnutls-3.1.23/ &&  ./configure --prefix=/usr && make -j`nproc` && make install

# (from build_helper)
RUN apt-get -qy install autoconf  \
 automake  \
 bison     \
 build-essential \
 cmake \
 cmake-curses-gui  \
 debhelper \
 flex  \
 g++ \
 gcc \
 gdb \
 libgcrypt-dev \
 libidn11-dev \
 libmysqlclient-dev \
 libpq-dev \
 libsctp1 \
 libsctp-dev \
 libxml2-dev \
 mercurial \
 python-dev \
 ssl-cert \
 swig 

# Run freediameter (hard dependencies on gnutls)
WORKDIR /root
RUN git clone https://gitlab.eurecom.fr/oai/freediameter.git -b eurecom-1.2.0  
WORKDIR /root/freediameter
RUN mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr ../ && make -j`nproc` && make install 

# PHPmyadmin for the MME database management
WORKDIR /root
RUN apt-get -qy install phpmyadmin \
 python-pexpect \
 php \
 libapache2-mod-php 

RUN apt-get -qy install check \
 phpmyadmin \
 python-dev \
 python-pexpect \
 unzip

#  install_asn1c_from_source
WORKDIR /root
RUN apt-get -qy install autoconf automake bison build-essential flex gcc libtool
RUN git clone https://gitlab.eurecom.fr/oai/asn1c.git 
RUN cd asn1c && ./configure && make && make install

#   install_libgtpnl_from_source

WORKDIR /root
RUN apt-get -qy install    autoconf  \
    automake  \
    build-essential \
    libmnl-dev

RUN  git clone git://git.osmocom.org/libgtpnl
RUN cd libgtpnl && autoreconf -fi && ./configure && make -j`nproc` && make install && ldconfig

RUN apt-get -qy install ethtool \
    iproute \ 
    vlan \
    tshark

# compiling OAI mme executable 
WORKDIR /root/openair-cn/build/mme
RUN cp CMakeLists.template CMakeLists.txt
RUN echo 'include(${CMAKE_CURRENT_SOURCE_DIR}/../CMakeLists.txt)' >> CMakeLists.txt
RUN mkdir build
WORKDIR /root/openair-cn/build/mme/build
RUN cmake -DOPENAIRCN_DIR=/root/openair-cn ../
RUN make -j`nproc`

# Configuration files
RUN mkdir -p /usr/local/etc/oai/freeDiameter
RUN cp /root/openair-cn/etc/mme.conf /usr/local/etc/oai/
RUN cp /root/openair-cn/etc/mme_fd.conf /usr/local/etc/oai/freeDiameter/
RUN sed -i s/"192.168.11.17\/24"/"192.168.142.20\/24"/g /usr/local/etc/oai/mme.conf
RUN sed -i s/"yang.openair4G.eur"/"mme.openair4G.eur"/g /usr/local/etc/oai/freeDiameter/mme_fd.conf
RUN sed -i s/"127.0.0.1"/"192.168.142.10"/g /usr/local/etc/oai/freeDiameter/mme_fd.conf

# Generation of certificate for diameter 
WORKDIR /root/
RUN mkdir demoCA && touch demoCA/index.txt && echo 01 > demoCA/serial
RUN openssl req  -new -batch -x509 -days 3650 -nodes -newkey rsa:1024 -out mme.cacert.pem -keyout mme.cakey.pem -subj /CN=mme.openair4G.eur/C=FR/ST=PACA/L=Aix/O=Eurecom/OU=CM
RUN openssl genrsa -out mme.key.pem 1024
RUN openssl req -new -batch -out mme.csr.pem -key mme.key.pem -subj /CN=mme.openair4G.eur/C=FR/ST=PACA/L=Aix/O=Eurecom/OU=CM
RUN openssl ca -cert mme.cacert.pem -keyfile mme.cakey.pem -in mme.csr.pem -out mme.cert.pem -outdir . -batch
RUN mv mme.cakey.pem mme.cert.pem mme.cacert.pem mme.key.pem /usr/local/etc/oai/freeDiameter/

ENTRYPOINT bash -x -c "sleep 17 &&  /root/openair-cn/build/mme/build/mme"