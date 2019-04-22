#!/bin/bash

# rerun: upgrade change

curl https://cht.sh/:cht.sh | sudo tee /usr/local/bin/cht.sh
chmod +x /usr/local/bin/cht.sh
# TODO: curl https://cheat.sh/:bash_completion > ~/.bash.d/cht.sh for completion
