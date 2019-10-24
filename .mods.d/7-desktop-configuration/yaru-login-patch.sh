#!/bin/bash

# rerun: change watch
# watch-file: /usr/share/gnome-shell/theme/Yaru/gnome-shell.css

sudo apt install -y ubuntu-wallpapers-maverick

THEME="/usr/share/gnome-shell/theme/Yaru"

cd $THEME
if [ -e ".git" ]; then
  if cat $THEME/gnome-shell.css | grep "md lb" > /dev/null; then
    # match, means we are still using patched
    sudo git reset --hard HEAD~
  fi # no match: was overriden by upgrade
  sudo rm -rf .git
  sudo cp gnome-shell.css gnome-shell.css.bak
fi

TMP=$(mktemp -d)
cd "$TMP"
sudo -E git init
touch patched
sudo chmod 777 .git/config
echo -e "[user]\n\temail = mkg20001@gmail.com\n\tname = Maciej Krüger\n\tusername = mkg20001\n[commit]\n\tgpgsign = false" >> .git/config
sudo -E git add patched
sudo -E git commit -m "init"

sudo sh -c 'echo "git diff HEAD~ > blue.patch && rm -rf .git && git init && sudo chmod 777 .git/config && echo -e "[user]\n\temail = mkg20001@gmail.com\n\tname = Maciej Krüger\n\tusername = mkg20001\n[commit]\n\tgpgsign = false" >> .git/config && git add patched && git commit -m init && cp '$THEME/gnome-shell.css' . && git add gnome-shell.css && git commit -m base gnome-shell.css && git apply blue.patch && git add gnome-shell.css && git commit -m blue && git format-patch -o '$SCRIPTFOLDER/yaru-login-patch' HEAD~~" > "$TMP/save-changes.sh"'
sudo -E git am "$SCRIPTFOLDER/yaru-login-patch/"*.patch

sudo cp "$THEME/gnome-shell.css" .
sudo -E git add gnome-shell.css
sudo -E git commit -m base
sudo -E git cherry-pick HEAD~

sudo cp -rp .git gnome-shell.css "$THEME"
