#!/bin/bash

# rerun: change watch
# watch-file: /usr/share/gnome-shell/theme/Yaru/gnome-shell.css

sudo apt install -y ubuntu-wallpapers-maverick

THEME="/usr/share/gnome-shell/theme/Yaru"

cd $THEME
if [ -e ".git" ]; then
  if cat $THEME/gnome-shell.css | grep "md lb" > /dev/null; then
    # match, means we are still using patched
    git reset --hard HEAD~
  fi # no match: was overriden by upgrade
  rm -rf .git
  cp gnome-shell.css gnome-shell.css.bak
fi

TMP=$(mktemp -d)
cd "$TMP"
git init
echo "[user]
	email = mkg20001@gmail.com
	name = Maciej Krüger
	username = mkg20001
" >> .git/config
touch patched
git add patched
git commit -m "init"

git am "$SCRIPTFOLDER/yaru-login-patch/"*.patch
echo "git diff HEAD~ > blue.patch && rm -rf .git && git init && git add patched && git commit -m init && cp $THEME/gnome-shell.css . && git add gnome-shell.css && git commit -m base gnome-shell.css && git apply blue.patch && git add gnome-shell.css && git commit -m blue && git format-patch -o '$SCRIPTFOLDER/yaru-login-patch' HEAD~~" > "$THEME/save-changes.sh"

cp "$THEME/gnome-shell.css" .
git add gnome-shell.css
git commit -m base
git cherry-pick HEAD~

sudo cp -rp .git gnome-shell.css "$THEME"
