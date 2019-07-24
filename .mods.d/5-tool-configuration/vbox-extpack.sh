#!/bin/bash

# rerun: change watch
# watch-file: /usr/bin/VBoxManage

VERSION=$(VBoxManage --version | tail -1 | cut -f 1 -d "r")
curl -Lo /tmp/Oracle_VM_VirtualBox_Extension_Pack-${VERSION}.vbox-extpack http://download.virtualbox.org/virtualbox/${VERSION}/Oracle_VM_VirtualBox_Extension_Pack-${VERSION}.vbox-extpack
yes | sudo VBoxManage extpack install --replace /tmp/Oracle_VM_VirtualBox_Extension_Pack-${VERSION}.vbox-extpack
rm -rf /tmp/Oracle_VM_VirtualBox_Extension_Pack-${VERSION}.vbox-extpack

