# docker-openairinterface-epc
OAI EPC running in docker-based containers from [OpenAirInterface project](https://gitlab.eurecom.fr/oai/openairinterface5g/wikis/home) develop code base. I am using an Ubuntu 17.04 as host for my tests.

# Status : DEPRECATED

Nowadays I am using nextEPC. Check my project at : https://github.com/ravens/docker-nextepc

## Configure 

Edit the various Dockerfile or override the corresponding arg variable to match your environement (i.e. UE IMSI, Ki, OPC etc.)

## Build

> docker-compose build --no-cache

## Run 

> docker-compose up 
