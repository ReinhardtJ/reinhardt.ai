#!/bin/bash

action=${1:-"start"}

case "$action" in
  start)
    docker-compose up -d nginx-proxy acme-companion
    ;;
  stop)
    docker-compose stop nginx-proxy acme-companion
    ;;
  restart)
    docker-compose restart nginx-proxy acme-companion
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
    ;;
esac