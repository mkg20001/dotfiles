#!/bin/bash

# this has to be first, so we have build tools installed for cjdns
sudo sh -c 'bash <(curl -Ss https://my-netdata.io/kickstart.sh) --dont-wait'
