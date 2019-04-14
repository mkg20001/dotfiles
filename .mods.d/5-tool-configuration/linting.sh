#!/bin/bash

# rerun: upgrade

npm i -g eslint standard
npm i -g eslint-config-aegir eslint-config-react-app eslint-config-standard eslint-config-standard-react # install 'em globally so I can reuse them everywhere
for plugin in import node no-only-tests promise react standard; do
  npm i -g "eslint-plugin-$plugin"
done
