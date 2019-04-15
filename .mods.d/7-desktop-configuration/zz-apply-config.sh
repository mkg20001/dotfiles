#!/bin/bash

# rerun: change watch
# watch-file: ~/.mods.d/7-desktop-configuration/dconf.conf

# extension setting backup - src https://gist.github.com/balderclaassen/d12cfb70b1695c11402116d8b7f79059
# dconf dump /org/gnome/shell/extensions

export MAIN="$SCRIPTFOLDER/pics"
cat "$SCRIPTFOLDER/dconf.conf" | sed "s|\$MAIN|$MAIN|g" | dconf load /
