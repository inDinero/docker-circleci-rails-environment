#!/usr/bin/env bash

set -ex

if [ "$1" == "docker-start" ]; then
  shift

  mysqld --initialize-insecure 2> /dev/null
  service mysql restart
  mysql -e 'CREATE USER ubuntu@localhost; GRANT ALL PRIVILEGES ON *.* to ubuntu@localhost; FLUSH PRIVILEGES;'

  service mongodb restart
  service redis-server restart
fi

exec "$@"
