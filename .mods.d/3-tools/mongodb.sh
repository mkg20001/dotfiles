#!/bin/bash

# rerun: change watch
# watch-file: /usr/bin/mongod
# watching binary so we can re-disable it after upgrades

sudo apt install mongodb -y
sudo systemctl disable mongodb # takes too much mem
