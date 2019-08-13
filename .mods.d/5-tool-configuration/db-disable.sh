#!/bin/bash

# rerun: change watch
# watch-file: /usr/bin/mongod /usr/bin/redis-server /usr/sbin/mysqld /usr/lib/postgresql/11/bin/postgres
# watching binary so we can re-disable it after upgrades

# takes too much mem
for service in mongodb redis-server postgresql@11-main; do
  sudo systemctl disable "$service"
done
