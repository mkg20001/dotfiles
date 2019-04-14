#!/bin/bash

# rerun: change watch
# watch-file: ~/.mods.d/7-desktop-configuration/dconf.conf

export MAIN="$SCRIPTFOLDER/pics"
cat "$SCRIPTFOLDER/dconf.conf" | sed "s|\$MAIN|$MAIN|g" | dconf load /
