#!/bin/bash

# rerun: watch
# watch-file: /etc/default/grub

# Makes diagnostics a LOT easier

sudo sed "s|quiet splash||g" -i /etc/default/grub
