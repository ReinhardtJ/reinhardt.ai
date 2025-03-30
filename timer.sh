#!/bin/bash

action=${1:-"start"}

case "$action" in
  start)
    docker-compose up -d no-bullshit-timer
    ;;
  stop)
    docker-compose stop no-bullshit-timer
    ;;
  restart)
    docker-compose restart no-bullshit-timer
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
    ;;
esac