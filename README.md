# reihardt.ai

This repository maintains the infrastructure running under [reinhardt.ai](https://reinhardt.ai) and [timer.reinhardt.ai](https://timer.reinhardt.ai).

# Setup
The setup uses docker with a docker-compose yaml file to define and run the 
services. Currently, the setup consists of 4 services:
- nginx-proxy // a nginx reverse proxy exposing the server and taking care of http/https traffic
- acme-companion // a service which automatically renews the SSL certificates
- obsidian-proxy // the obsidian proxy which replaces the publish.obsidian.me url for reinhardt.ai
- blazor-app todo
