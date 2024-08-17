#!/usr/bin/env bash

##
# Open a tmux session in a repo
##

function startSession() {
  cd "$1" && tmuxn "$2"
}

function _tmuxcn() {
  local repoPath
  repoPath="''${1:?Must define a repo}"
  #if [[ -z "$repoShortPath" ]]
  #then
  #  exit 1
  #else
  #fi

  local pathToCheck
  pathToCheck="$CODE_HOME/$repoPath"
  [ -d "$pathToCheck" ] && startSession "$pathToCheck" "$repoPath"

  pathToCheck="$CODE_HOME/feltnerm/$repoPath"
  [ -d "$pathToCheck" ] && startSession "$pathToCheck" "feltnerm/$repoPath"

  pathToCheck="$CODE_HOME/feltnerm/scratch$repoPath"
  [ -d "$pathToCheck" ] && startSession "$pathToCheck" "scratch/$repoPath"

  pathToCheck="$CODE_HOME/scratch/$repoPath"
  [ -d "$pathToCheck" ] && startSession "$pathToCheck" "scratch/$repoPath"

  echo -e "No repo found"
}
_tmuxcn "$@"
