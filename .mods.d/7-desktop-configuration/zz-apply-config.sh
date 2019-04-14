#!/bin/bash

export MAIN="$SCRIPTFOLDER/pics"
cat "$SCRIPTFOLDER/dconf.conf" | sed "s|\$MAIN|$MAIN|g" | dconf load /
