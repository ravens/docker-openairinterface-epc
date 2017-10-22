FROM ubuntu:16.04
MAINTAINER Yan Grunenberger <yan@grunenberger.net>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -yq dist-upgrade 

# General utilities
RUN apt-get -qy install kmod git wget apt-utils

# Adding OAI certificates
RUN mkdir -p /usr/local/share/ca-certificates/eurecom 
RUN echo -n | openssl s_client -showcerts -connect gitlab.eurecom.fr:443 2>/dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /usr/local/share/ca-certificates/eurecom/eurecom.crt
RUN update-ca-certificates

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



RUN apt-get -qy install autoconf  \
    automake  \
    bison     \
    build-essential \
    cmake \
    cmake-curses-gui  \
    doxygen \
    doxygen-gui\
    flex  \
    gccxml \
    gdb  \
    git \
    pkg-config \
    subversion

RUN apt-get -qy install guile-2.0-dev \
    libconfig8-dev \
    libgcrypt11-dev \
    libgmp-dev \
    libhogweed? \
    libgtk-3-dev \
    libidn2-0-dev \
    libidn11-dev \
    libpthread-stubs0-dev \
    libtool \
    libxml2 \
    libxml2-dev \
    mscgen \
    openssl \
    python

RUN apt-get -qy install  ethtool \
    iperf \
    iproute \
    vlan \
    tshark

RUN apt-get -qy install python-dev \
    python-pexpect \
    unzip 

# compiling OAI mme executable 
WORKDIR /root/openair-cn/build/

WORKDIR /root/openair-cn/build/spgw
RUN cp /root/openair-cn/build/spgw/CMakeLists.template ./CMakeLists.txt
RUN echo 'include(${CMAKE_CURRENT_SOURCE_DIR}/../CMakeLists.txt)' >> ./CMakeLists.txt
RUN mkdir build
WORKDIR /root/openair-cn/build/spgw/build
RUN cmake -DOPENAIRCN_DIR=/root/openair-cn ../
RUN make -j`nproc`


RUN mkdir -p /usr/local/etc/oai/freeDiameter
RUN cp /root/openair-cn/etc/spgw.conf /usr/local/etc/oai/
RUN sed -i s/"192.168.11.17"/"192.168.142.30"/g /usr/local/etc/oai/spgw.conf
RUN sed -i s/"eth3"/"eth1"/g /usr/local/etc/oai/spgw.conf

#  PGW_INTERFACE_NAME_FOR_SGI            = "eth3";                         # STRING, YOUR NETWORK CONFIG HERE
#        PGW_MASQUERADE_SGI                    = "no";                           # STRING, {"yes", "no"}. YOUR NETWORK CONFIG HERE, will do NAT for you if you put "yes".
#        UE_TCP_MSS_CLAMPING                   = "no";                           # STRING, {"yes", "no"}. 

RUN apt-get -qy install iptables
ENTRYPOINT bash -x -c "/root/openair-cn/build/spgw/build/spgw"
