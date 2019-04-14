#!/bin/bash

# rerun: watch change
# watch.file: /etc/ssh/sshd_config

sshdc="/etc/ssh/sshd_config"

sudo apt install -y openssh-server

sudo cp "$sshdc" "$sshdc.bak"
# comment out whatever currently is set
sudo sed -r "s|^(PermitRootLogin*)|#\1|g" -i "$sshdc"
sudo sed -r "s|^(PermitEmptyPasswords*)|#\1|g" -i "$sshdc"
sudo sed -r "s|^(PasswordAuthentication*)|#\1|g" -i "$sshdc"
sudo sed -r "s|^(PubkeyAuthentication*)|#\1|g" -i "$sshdc"
# override
echo -e "PermitRootLogin no\nPermitEmptyPasswords no\nPasswordAuthentication no\nPubkeyAuthentication yes" | sudo tee -a "$sshdc"

# reload
sudo service ssh reload

# firewall
sudo ufw allow openssh comment SSH
