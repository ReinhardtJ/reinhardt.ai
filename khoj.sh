#!/bin/bash

action=${1:-"start"}

case "$action" in
  start)
    docker-compose up -d khoj-database khoj-sandbox khoj-search khoj-server
    ;;
  stop)
    docker-compose stop khoj-database khoj-sandbox khoj-search khoj-server
    ;;
  restart)
    docker-compose restart khoj-database khoj-sandbox khoj-search khoj-server
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
    ;;
esac