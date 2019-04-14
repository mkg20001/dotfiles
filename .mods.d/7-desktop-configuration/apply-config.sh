#!/bin/bash

export MAIN="$SCRIPTFOLDER/pics"
sed "s|\$MAIN|$MAIN|g" <("$SCRIPTFOLDER/dconf.conf") | dconf load /
