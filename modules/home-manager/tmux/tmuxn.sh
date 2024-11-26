#!/usr/bin/env bash

##
# Create a new tmux session
##

function _tmuxn() {
  local sessionName
  sessionName="${1:-}"

  if [[ -z $sessionName ]]; then
    local currentDir
    local baseDir

    currentDir=$(pwd)
    baseDir=$(basename "$currentDir")

    sessionName="$baseDir"
  fi

  echo "Creating tmux session @ $sessionName"
  tmux new-session -s "$sessionName"
}

_tmuxn "$@"
