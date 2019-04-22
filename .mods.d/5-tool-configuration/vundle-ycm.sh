#!/bin/bash

# rerun: upgrade change watch
# watch-file: /etc/lsb-release
# script stops working after dist-upgrades, rebuild should fix that

cd $HOME/.vim/bundle/YouCompleteMe
python3 install.py --rust-completer --java-completer
