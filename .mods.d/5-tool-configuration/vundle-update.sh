#!/bin/bash

# rerun: change watch
# watch-file: ~/.vimrc

if [ -z "$SCRIPTFOLDER" ]; then
  vim +PluginInstall
else
  vim +PluginInstall +qall # run headless
fi
