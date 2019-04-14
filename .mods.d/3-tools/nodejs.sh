#!/bin/bash

wget --quiet -O - https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
VERSION=node_10.x
DISTRO="$(lsb_release -s -c)"
echo "deb https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee /etc/apt/sources.list.d/nodesource.list
echo "deb-src https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list
sudo apt-get update
sudo apt install -y nodejs

# there is literally no way arround this, except for a bunch of sudo+env hacks
sudo chown "$(whoami):$(whoami)" /usr/lib/node_modules
sudo chown "$(whoami):$(whoami)" /usr/bin
