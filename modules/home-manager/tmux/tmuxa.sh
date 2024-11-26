#!/usr/bin/env bash

##
# Create a new tmux session
##

# attach to a tmux session in the current directory
function _tmuxa() {
  local sessionName
  sessionName="${1:-}"

  if [[ -z $sessionName ]]; then
    local currentDir
    local baseDir

    currentDir=$(pwd)
    baseDir=$(basename "$currentDir")

    sessionName="$baseDir"
  fi

  echo "Attaching tmux session @ $sessionName"
  tmux attach-session -t "$sessionName"
}

_tmuxa "$@"
