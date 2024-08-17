#!/usr/bin/env bash

##
# Quick search for a tmux session
##

function _tmux-ls() {
  local query
  query="${1:-}"

  local search
  search=$(tmux list-sessions | \
    fzf --ansi \
    --header tmux-sessions \
    --no-info \
    --query="$query" \
    --delimiter ":" \
    --preview "tmux list-windows -t {1}" \
    --preview-label session)

  if [[ -n "$search" ]]
  then
    echo -e "$search"
  fi
}

_tmux-ls "$@"
