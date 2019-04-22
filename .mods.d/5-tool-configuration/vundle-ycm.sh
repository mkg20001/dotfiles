#!/bin/bash

# rerun: upgrade change

cd $HOME/.vim/bundle/YouCompleteMe
python3 install.py --rust-completer --java-completer
