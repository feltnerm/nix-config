#!/usr/bin/env zsh
# create a tmux session in the current directory
function tmuxn() {
if [[ -z "$1" ]]
then
  tmux new-session -s $(basename $(pwd))
else
  tmux new-session -s "$1"
fi
}

# attach to a tmux session in the current directory
function tmuxa() {
if [[ -z "$1" ]]
then
  tmux attach-session -t $(basename $(pwd))
else
  tmux attach-session -t "$1"
fi
}
