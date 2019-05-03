#!/bin/bash

# TODO: somehow write "1\n" to sh
wget https://sh.rustup.rs -O /tmp/rustup
chmod +x /tmp/rustup
echo -e "1\n" | sh /tmp/rustup
rm /tmp/rustup
source $HOME/.cargo/env

rustup install stable
rustup install nightly
