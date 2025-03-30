#!/bin/bash

action=${1:-"start"}

case "$action" in
  start)
    docker-compose up -d obsidian-proxy
    ;;
  stop)
    docker-compose stop obsidian-proxy
    ;;
  restart)
    docker-compose restart obsidian-proxy
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
    ;;
esac