#!/usr/bin/env bash

##
# Attach a tmux session in a repo
##

function attachSession() {
  cd "$1" && tmuxa "$2"
}

function _tmuxca() {
  local repoPath
  repoPath="''${1:?Must define a repo}"
  #if [[ -z "$repoShortPath" ]]
  #then
  #  exit 1
  #else
  #fi

  local pathToCheck
  pathToCheck="${codeDir}/$repoPath"
  [ -d "$pathToCheck" ] && attachSession "$pathToCheck" "$repoPath"

  pathToCheck="${codeDir}/feltnerm/$repoPath"
  [ -d "$pathToCheck" ] && attachSession "$pathToCheck" "feltnerm/$repoPath"

  pathToCheck="${codeDir}/feltnerm/scratch$repoPath"
  [ -d "$pathToCheck" ] && attachSession "$pathToCheck" "scratch/$repoPath"

  pathToCheck="${codeDir}/scratch/$repoPath"
  [ -d "$pathToCheck" ] && attachSession "$pathToCheck" "scratch/$repoPath"

  echo -e "No repo found"
}
_tmuxca "$@"
