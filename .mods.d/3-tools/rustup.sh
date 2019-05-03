#!/bin/bash

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh /dev/stdin -y
source $HOME/.cargo/env

rustup install stable
rustup install nightly
