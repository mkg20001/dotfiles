#!/bin/bash

EXT="$HOME/.local/share/gnome-shell/extensions/"
for e in $(find "$EXT" -maxdepth 1 -type d -name "*@*" -exec /usr/bin/basename {} \;); do
  if [ -e "$EXT/$e/id" ]; then
    ID=$(cat "$EXT/$e/id")
  else
    ID=$(curl -s "https://extensions.gnome.org/ajax/detail/?uuid=$e" | jq .pk)
    sleep .1s
    echo "$ID" > "$EXT/$e/id"
  fi

  VER=$(cat "$EXT/$e/metadata.json" | jq .version)

  echo "$ID@$VER"
done

