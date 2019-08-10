#!/bin/bash

# rerun: upgrade change

configs="aegir react-app standard standard-react"
plugins="import node no-only-tests promise react standard"

npm i -g eslint standard

pkgs=()

for config in $configs; do
  pkgs+=("eslint-config-$config")
done

for plugin in $plugins; do
  pkgs+=("eslint-plugin-$plugin")
done

npm i -g "${pkgs[@]}"
cd /usr/lib/node_modules/eslint
npm i "${pkgs[@]}"
