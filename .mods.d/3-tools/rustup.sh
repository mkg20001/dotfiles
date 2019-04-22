#!/bin/bash

# TODO: somehow write "1\n" to sh
curl https://sh.rustup.rs -sSf | sh

rustup install stable
rustup install nightly
