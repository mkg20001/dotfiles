#!/bin/bash

_2fa() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts=$(echo $(pass ls | grep " _" | sed -r "s|[^a-z]+([a-z]+)$|\1|g"))

  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

complete -F _2fa 2fa
