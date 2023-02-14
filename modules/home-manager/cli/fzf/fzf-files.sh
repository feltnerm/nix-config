#!/usr/bin/env bash

##
# Quick search for file contents in the current directory.
##

PREVIEW_COMMAND="bat \
  --theme gruvbox-dark \
  --paging=never \
  --style=full \
  --color=always \
  --highlight-line {2} \
  {1}"
# --preview-window '~3,+{2}+3/2'

# better version, reloads as you type using rg
function _fzf-files-reload() {
    local rgCommand
    local query
    local dir

    query="${1:-}"
    dir="${2:-.}"
    rgCommand="rg --smart-case --vimgrep --column --pretty --line-number"

    local search
    export FZF_DEFAULT_COMMAND="$rgCommand $query ${dir}"
    search=$(fzf \
      --ansi \
      --bind "change:reload:$rgCommand {q} ${dir} || true" \
      --disabled \
      --header livegrep \
      --no-info \
      --preview "$PREVIEW_COMMAND" \
      --preview-label file \
      --preview-window '~3,+{2}+3/2' \
      --delimiter ":" \
      --query="$query"
    )
    export FZF_DEFAULT_COMMAND=""

    if [[ -n "$search" ]]
    then
      echo -e "$dir/$search" | cut -d ":" -f 1
    fi
}

# searches for files using rg then you can further filter them
function _fzf-files-quick() {
    local query
    local dir

    query="${1:-}"
    dir="${2:-.}"

    local search
    search=$(rg --smart-case --vimgrep --pretty --column --line-number "$query" "$dir" | \
      fzf --ansi \
      --header livegrep \
      --no-info \
      --preview-label file \
      --delimiter ":" \
      --preview "$PREVIEW_COMMAND"
    )

    if [[ -n "$search" ]]
    then
      echo -e "$dir/$search" | cut -d ":" -f 1
    fi
}

# _fzf-files "$@"
_fzf-files-reload "$@"
