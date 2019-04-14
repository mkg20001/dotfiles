#!/bin/bash

# rerun: upgrade
# version: v20.2

CJD_VER="v20.2"
cd /opt
if [ -e cjdns ]; then
  cd cjdns
  sudo git fetch -p
  sudo git reset --hard HEAD
  sudo git checkout cjdns-$CJD_VER
else
  sudo git clone https://github.com/cjdelisle/cjdns.git -b cjdns-$CJD_VER
  cd cjdns
fi

sudo git clean -dxf
# patch for test-runner timeout
echo ZGlmZiAtLWdpdCBhL25vZGVfYnVpbGQvVGVzdFJ1bm5lci5qcyBiL25vZGVfYnVpbGQvVGVzdFJ1bm5lci5qcwppbmRleCA4N2FjZDM4MC4uODA0NDE0NzcgMTAwNjQ0Ci0tLSBhL25vZGVfYnVpbGQvVGVzdFJ1bm5lci5qcworKysgYi9ub2RlX2J1aWxkL1Rlc3RSdW5uZXIuanMKQEAgLTE1LDcgKzE1LDcgQEAgdmFyIFNwYXduID0gcmVxdWlyZSgnY2hpbGRfcHJvY2VzcycpLnNwYXduOwogdmFyIEh0dHAgPSByZXF1aXJlKCJodHRwIik7CiB2YXIgRnMgPSByZXF1aXJlKCJmcyIpOwogCi12YXIgVElNRU9VVCA9IDE1MDAwOwordmFyIFRJTUVPVVQgPSA2MDAwMDA7CiAKIHZhciBwYXJzZVVSTCA9IGZ1bmN0aW9uICh1cmwpCiB7Cg== | base64 -d | sudo git apply -
# TODO remove patch above once https://github.com/cjdelisle/cjdns/pull/1178/files gets released
sudo sh -c "TestRunner_TIMEOUT=600000 ./do"
sudo rm -f /usr/bin/cjdroute
sudo cp -p /opt/cjdns/cjdroute /usr/bin
[ ! -e /etc/cjdroute.conf ] && sudo bash -c '(umask 077 && ./cjdroute --genconf > /etc/cjdroute.conf)'

port=$(sudo cat /etc/cjdroute.conf | grep "bind" | grep "0.0.0.0" | grep "[0-9][0-9][0-9]*" -o)
sudo ufw allow "$port/udp" comment CJDNS

sudo cp contrib/systemd/cjdns.service /etc/systemd/system/
sudo cp contrib/systemd/cjdns-resume.service /etc/systemd/system/

sudo systemctl enable cjdns
sudo systemctl restart cjdns
