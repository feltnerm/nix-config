#!/usr/bin/env bash

##
# Quick search for a tmux session
##

function _tmux-ls-switch() {
  local query
  query="${1:-}"

  local search
  search=$(tmuxls "$query")

  local sessionName
  sessionName=$(echo "$search" | cut -d: -f1)

  if [[ -z ${TMUX:-} ]]; then
    # assume we are not in a tmux session
    tmuxa "$sessionName"
  else
    # we are in tmux
    tmux detach -E "tmuxa $sessionName"
  fi
}

_tmux-ls-switch "$@"
