#!/bin/bash

# rerun: watch

me=$(whoami)
sudo su postgres -c "psql -c 'CREATE ROLE $me; ALTER ROLE $me WITH login; ALTER ROLE $me WITH superuser; ALTER ROLE $me WITH createdb;'"
sudo su postgres -c "psql -c 'CREATE DATABASE $me;'"
