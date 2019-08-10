#!/bin/bash

LOG=$(mktemp)

echo "LOG $LOG"
echo "---"

time bash -ex >"$LOG" 2>&1 mods.sh "$@"
