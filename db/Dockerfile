FROM mysql:5.6
MAINTAINER Yan Grunenberger <yan@grunenberger.net>

#### CUSTOMIZE YOUR FIRST SIM DETAILS
ARG IMSI='901550000000000'
ARG MSISDN='6789'
ARG KI=0x912e7221941577df083e1591d35f4c42
ARG OPC=0x4487d12562bd21df3b076852f4d74eec
ARG APN='internet'

#### CUSTOMIZE YOUR MME DETAILS
ARG REALM='openair4G.eur'
ARG MME='mme.openair4G.eur'

############################################ Docker build instructions

ENV MYSQL_ROOT_PASSWORD=linux

#RUN apt-get update && apt-get -qy install curl
#RUN curl https://gitlab.eurecom.fr/oai/openair-cn/raw/develop/src/oai_hss/db/oai_db.sql -o  /docker-entrypoint-initdb.d/oai_db.sql
ADD oai_db.sql  /docker-entrypoint-initdb.d/oai_db.sql


# Customize the SQL based on the arguments passed on build time

# MME settings
RUN sed -i s/'mme.openair4G.eur'/$MME/g /docker-entrypoint-initdb.d/oai_db.sql
RUN sed -i s/'openair4G.eur'/$REALM/g /docker-entrypoint-initdb.d/oai_db.sql

# SIM card record
RUN sed -i s/'oai.ipv4'/$APN/g /docker-entrypoint-initdb.d/oai_db.sql

RUN sed -i s/208920100001100/$IMSI/g /docker-entrypoint-initdb.d/oai_db.sql
RUN sed -i s/33638020000/$MSISDN/g /docker-entrypoint-initdb.d/oai_db.sql
RUN sed -i s/0x8baf473f2f8fd09487cccbd7097c6862/$KI/g /docker-entrypoint-initdb.d/oai_db.sql
RUN sed -i s/0xe734f8734007d6c5ce7a0508809e7e9c/$OPC/g  /docker-entrypoint-initdb.d/oai_db.sql

