#!/bin/bash

# rerun: watch change
# watch-file: ~/.vimrc

if [ -z "$SCRIPTFOLDER" ]; then
  vim +PluginInstall
else
  vim +PluginInstall +qall # run headless
fi
