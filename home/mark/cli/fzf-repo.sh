#!/usr/bin/env bash

##
# Quick search for a repo in the $codeDir
##

PREVIEW_COMMAND="exa \
  --icons \
  --git-ignore \
  --group-directories-first \
  --git \
  -1"

function _fzf-repo() {
    local reposDir
    local query
    local repo
    local path

    query="${1:-}"
    reposDir="${2:-$CODE_HOME}"
    repo=$(cd "$CODE_HOME" && tree -L 1 -dfiC -- * | \
      fzf --query "$query" \
        --scheme=path \
        --filepath-word \
        --ansi \
        --header code \
        --no-info \
        --preview-label files \
        --preview "$PREVIEW_COMMAND {+}" )

    if [[ -n "$repo" ]]
    then
      path="$reposDir/$repo"
      echo -e "$path"
    fi
}

_fzf-repo "$@"
