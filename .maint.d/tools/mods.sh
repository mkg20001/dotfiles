#!/bin/bash

set -e

DB="$HOME/.config/dotfiles/db"
HASHDB="$DB/hashes"
mkdir -p "$HASHDB"

echo -n "Authorize sudo once, to store authorization... "
sudo /bin/bash -c echo -n
echo "...stored"

log() {
  echo "*** $*"
}

contains() {
  match="$1"
  shift
  for e in "$@"; do
    if [ "$e" == "$match" ]; then
      return 0
    fi
  done
  return 1
}

get_var() {
  OUT=$(cat "$script" | grep "^# *$1:" | sed "s|^# *$1: *||")
  if [ -z "$OUT" ]; then
    echo "$2"
  else
    echo "$OUT"
  fi
}

_file_hash() {
  FILE="$1"
  FILE_SAFE=$(echo "$FILE" | sed "s|/|@|g")
  FDB="$HASHDB/$FILE_SAFE"
  CURHASH=$(sudo sha256sum "$FILE" | fold -w 64 | head -n 1)
}

store_file_hash() {
  _file_hash "$@"
  echo "$CURHASH" > "$FDB"
}

has_file_hash() {
  _file_hash "$@"
  if [ ! -e "$FDB" ]; then
    return 1
  fi
}

has_changed_hash() {
  if ! has_file_hash "$@"; then # this calls _file_hash
    log "ERROR: CANNOT CHECK HASH CHANGE IF HASH NOT IN DB" >&2
    exit 2
  fi
  if [ "$CURHASH" == "$(cat $FDB)" ]; then
    return 1
  else
    return 0
  fi
}

has_changed_hash_multiple() {
  res=1

  for file in "$@"; do
    if has_changed_hash "$file"; then
      res=0
    fi
  done

  return $res
}

has_file_hash_multiple() {
  for file in "$@"; do
    has_file_hash "$file"
  done
}

store_db_val() {
  echo "$2" > "$DB/$1"
}

read_db_val() {
  cat "$DB/$1"
}

compare_db_val() {
  if [ "$2" != "$(cat "$DB/$!")" ]; then
    return 0
  else
    return 1
  fi
}

rem() {
  return 1
}

SCRIPTS=$(find "$(dirname $(dirname $(dirname $(readlink -f $0))))/.mods.d" -iname "*.sh" | sort)
cd "$HOME"

# TODO: proper argv handling

TARGET="$1"
if [ -z "$TARGET" ]; then
  TARGET="sync"
fi

for script in $SCRIPTS; do
  export SCRIPTFOLDER="$(dirname $script)"
  export MODFOLDER="$(dirname $SCRIPTFOLDER)"
  export MAINFOLDER="$(dirname $MODFOLDER)"

  rerun=($(get_var rerun change)) # rce, but all of this is rce anyways so why bother?
  version=$(get_var version)
  files=($(get_var watch-file | sed "s|~|$MAINFOLDER|g"))

  id="$(basename $(dirname $script))-$(basename $script)"

  if
    { ! has_file_hash "$script" && task="Installing"; } || rem if script isnt installed || \
    { has_changed_hash "$script" && contains "change" "${rerun[@]}" && task="Updating"; } || rem or if it changed and rerun change || \
    { [ "$TARGET" == "upgrade" ] && contains "upgrade" "${rerun[@]}" && [ -z "$version" ] && task="Upgrading"; } || rem or if target upgrade, and without version || \
    { [ "$TARGET" == "upgrade" ] && contains "upgrade" "${rerun[@]}" && ! compare_db_val "$id-version" "$version" && task="Upgrading"; } || rem or if target upgrade, and with different version || \
    { contains "version" "${rerun[@]}" && ! compare_db_val "$id-version" "$version" && task="Upgrading"; } || rem or if rerun version, and with different version || \
    { (! has_file_hash_multiple "${files[@]}" || has_changed_hash_multiple "${files[@]}") && contains "watch" "${rerun[@]}" && task="Re-applying"; } || rem or some files have changed that the script watches || \
  false; then
    log "$task $id..."
    bash -e "$script"
    log "DONE!"

    for file in "${files[@]}"; do
      store_file_hash "$file"
    done
    store_file_hash "$script"
    store_db_val "$id-version" "$version"
  else
    log "Skipping $id..."
    # TODO: warning about file-change
  fi
done
