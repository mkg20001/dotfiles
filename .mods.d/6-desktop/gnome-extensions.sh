#!/usr/bin

# rerun: upgrade change

# extensions.gnome.org installer - src https://github.com/brunelli/gnome-shell-extension-installer
wget -O /tmp/gnome-shell-extension-installer "https://github.com/brunelli/gnome-shell-extension-installer/raw/master/gnome-shell-extension-installer"
install -o root -g root -m 755 /tmp/gnome-shell-extension-installer /usr/bin/gnome-shell-extension-installer

i() { gnome-shell-extension-installer "$@"; }

i 779 # clipboard-indicator
i 1465 # desktop-icons
i 841 # freon
i 1319 # gsconnect
i 1285 # hotel-manager
i 1287 # unite
i 19 # user themes

# extension setting backup - src https://gist.github.com/balderclaassen/d12cfb70b1695c11402116d8b7f79059
# dconf dump /org/gnome/shell/extensions
dconf load /org/gnome/shell/extensions <"$SCRIPTFOLDER/gnome-extensions.conf"
