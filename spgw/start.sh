#!/bin/bash
sed -i s/"192.168.11.17"/"$SGW_IPV4_ADDRESS_FOR_S1U_S12_S4_UP"/g /usr/local/etc/oai/spgw.conf
sed -i s/"eth3"/"$PGW_INTERFACE_NAME_FOR_SGI"/g /usr/local/etc/oai/spgw.conf

# Start spgw
sleep 15 && /root/openair-cn/build/spgw/build/spgw
