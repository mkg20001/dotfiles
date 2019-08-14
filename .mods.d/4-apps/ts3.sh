#!/bin/bash

# rerun: never

DL=$(curl -s https://teamspeak.com/en/downloads/ | grep -o "https.*run" | grep amd64 | uniq)
wget -O /tmp/ts3.run "$DL" --progress=dot:giga
sed "s|^MS_PrintLicense$|true|g" -i /tmp/ts3.run 
chmod +x /tmp/ts3.run
/tmp/ts3.run --target "$HOME/.ts3"
rm /tmp/ts3.run
