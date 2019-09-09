#!/bin/bash

export PATH="$PATH:$HOME/.bin"

for f in $(dir "$HOME/.bash.d"); do
  . "$HOME/.bash.d/$f"
done

if [ -d "$HOME/.private.d/.bash.d" ]; then
  for f in $(dir "$HOME/.private.d/.bash.d"); do
    . "$HOME/.private.d/.bash.d/$f"
  done
fi

# Colors

RED='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color
bold=$(tput bold)
normal=$(tput sgr0)

# Rust

source $HOME/.cargo/env

# Go

export GOPATH="$HOME/Go-Dev/gopath"
[[ -d "/usr/lib/go-1.8" ]] && export PATH="$PATH:/usr/lib/go-1.8/bin"

# Android

if [ -e "$HOME/Android-Dev/android-studio/jre" ]; then
  export ANDROID_HOME="$HOME/Android-Dev/Sdk"
  export USE_CCACHE=1
  export CCACHE_COMPRESS=1
  export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"
  export JAVA_HOME="$HOME/Android-Dev/android-studio/jre"
else
  export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
fi

alias gradle="./gradlew"

# Node

alias _npmaudit="npm_config_registry=https://registry.npmjs.org npm audit"
alias _npmmv="mv node_modules /tmp/node_modules_trash.$$.\$RANDOM -v"
alias _purgeandtesti="rm -rfv node_modules/ package-lock.json .cache && ncu -u && ionice -c3 npm i && npm test"
alias renpmi="rm -rfv node_modules/ package-lock.json && npm i"
alias upnpmi="rm -rfv node_modules/ package-lock.json && ncu -u && npm i"
alias lintloop="while ! aegir lint; do echo; done && echo OK"
alias npmpu="npm_config_registry=https://registry.npmjs.org npm publish"
alias _npm_release='function _release() { npm version "$1" && npmpu && pu && pu --tags; }; _release'
alias _npm_release_patch="npm version patch && pu && pu --tags && npmpu"
alias _aegir_release="npm_config_registry=https://registry.npmjs.org MASTER_PUSH_OVERRIDE=1 npx aegir release"
alias nup="npm_config_registry=https://registry.npmjs.org ncu -u"
alias nreg="npm_config_registry=https://registry.npmjs.org "

# Node debug/test

alias debugcol="npm link supports-color"
alias debug="nodemon -x DEBUG=*"
alias _testdebug="nodemon -x 'DEBUG=* npm run test'"
alias _testdebugc="nodemon -x 'DEBUG=* npm run test:nocov'"
alias _test="nodemon -x 'npm run test'"
alias _testc="nodemon -x 'npm run test:nocov'"
alias _xvfbtest="xvfb-run nodemon -x npm test"
alias nrun='nodemon index.js | bunyan -l 0'

# Git

alias _mykeys="(echo SSH && echo && cat $HOME/.ssh/id_rsa.pub && echo && echo GPG && echo && gpg2 --armor --export $MYKEY)"
alias gac='function _commit(){ git commit -m "$1" "$2"; }; _commit'
alias simc='function _commit(){ git commit -m "$1 $2" "$2"; }; _commit'
alias fpu='function _fpu() { git commit -m "$*" . && git push; }; _fpu'
alias pu="git push"
alias gc='function _gc() { git commit -m "$*"; }; _gc'
alias gcpu='function _gc() { git commit -m "$*" && git push; }; _gc'
alias gca='function _gca() { git commit . -m "$*"; }; _gca'
alias gcp='function _gcp() { git commit -m "$*" && git push; }; _gcp'
alias gaa="git add . && git status"
alias ga="function _ga() { git add $* && git status; }; _ga"
alias gs="git status"
alias gdiff="git diff"
alias goto="git branch"
alias _pu='torify git push'
alias _prpull='function _prpull { git fetch origin "pull/$1/head:pr-$1" && git goto "pr-$1"; }; _prpull'
alias _gclean="git gc --aggressive"

alias _unhook="rm -rfv .git/hooks"
alias _pureb="git pull ; git rebase origin/master && pu"
alias _git2ssh='git remote set-url origin $(git remote -v | grep "^origin" | tr "\t" "\n" | tr " " "\n" | head -n 2 | tail -n 1 | sed -r "s|https*://([a-z0-9.]+)/(.+)|git@\1:\2|g")'
alias _baka="for f in \$(git clean -dxn | sed 's|Würde ||g' | sed 's| löschen||g'); do mkdir -p $(dirname ../bakbak/\$f); mv \$f ../bakbak/\$f; done"

# Other

alias nano="vim"
alias _tor=". torsocks on"
alias _t="torify"
alias no="yes | sed 's|y|n|g'"
alias ldiff='function _ldiff() { sed -r "s|(.)|\1\n|g" "$1" > /tmp/ldiffA && sed -r "s|(.)|\1\n|g" "$2" > /tmp/ldiffB && meld /tmp/ldiffA /tmp/ldiffB; }; _ldiff "$@"' # line diff
alias atom="ionice -c 3 /usr/bin/atom"
alias wireshark="_w() { LC_ALL=C wireshark \"\$@\" & }; _w"
alias ts3="bash $HOME/.ts3client/TS3/ts3client_runscript.sh"
alias seddot="sed \"s|[^].[^ ]|:|g\""
alias squashfile='function _squashfile() { mksquashfs "$1" "$2$1.squashfs" -comp lzma; }; _squashfile'
alias yataq="wine .wine/drive_c/Program\ Files\ \(x86\)/YaTQA/yatqa.exe"
alias usbtty="screen /dev/ttyUSB0 115200"
alias usbtty2="sudo screen /dev/ttyUSB0 115200"
alias curlpost='curl --header "Content-Type: application/json" --request POST --data'
alias curlput='curl --header "Content-Type: application/json" --request PUT --data'
alias sysrq='function _sysrq() { sudo sh -c "echo $1 > /proc/sysrq-trigger"; }; _sysrq'
alias _syncclean='find -iname "*sync-conflict*" -print -delete'

function _mktmp() {
  PREV="$PWD"
  _TMP="$(mktemp -d)"
  cd "$_TMP"
}


function _ltmp() {
  [ -z "$_TMP" ] && return 0
  cd "$PREV"
  rm -rfv "$_TMP"
}

# "Upgrades"

alias python="python3"
# alias pip="pip3"
alias py="python"
alias gpg="gpg2"
alias python="python3"
alias dc="docker-compose"

# Bash Aliases

if [ -e "/home/maciej/.acme.sh/acme.sh.env" ]; then
  . "/home/maciej/.acme.sh/acme.sh.env"
fi

alias aedit="nano $HOME/.bash_aliases && source $HOME/.bash_aliases"
alias areload="source $HOME/.bash_aliases"
alias swapfree="sudo swapoff -a; sudo swapon -a"
alias swapumount="sudo swapoff -a"
alias freetty="chmod 777 $(tty)"
alias music="sudo open && (sudo -E ionice -c1 su maciej -c rhythmbox &)"
alias fys='function _fys() { sudo -E ionice -c1 nice su maciej -c "$*" ; }; _fys'
alias fyss='function _fyss() { sudo -E ionice -c1 nice "$@" ; }; _fyss'
alias pall='while true; do sudo progress | grep -v "^No "; done'
alias _isthisflashdeadyet='sudo badblocks -b 4096 -c 4096 -n -s'
alias ytdl='function _ytdl() { for v in "$@"; do youtube-dl -x --audio-format best $v ; done ; }; _ytdl'

# Banners and stuff

showbanner=true

alias _asciinema_rec="NO_BANNER=1 asciinema rec"

[ "$NO_BANNER" == "1" ] && showbanner=false

if $showbanner; then
  # Run
  clear # fixes some issues

  normal=$(tput sgr0)
  # Show a nice htop header
  node $HOME/.htop.js
  echo $normal
fi

