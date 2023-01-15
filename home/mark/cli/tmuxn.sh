#!/usr/bin/env bash

##
# Create a new tmux session
##

function _tmuxn() {
  local sessionName
  sessionName="${1:-}"
  if [[ -z "$sessionName" ]]
  then
    local currentDir
    local baseDir

    currentDir=$(pwd)
    baseDir=$(basename "$currentDir")

    tmux new-session -s "$baseDir"
  else
    tmux new-session -s "$sessionName"
  fi
}

_tmuxn "$@"
