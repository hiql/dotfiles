#!/usr/bin/env bash

NAME=$1

function get_shell_icon() {
  local default_shell_icon="󰙵"
  local shell_icon
  shell_icon="$(tmux show -gqv '@tmux-icon-shell-icon')"
  if [ "$shell_icon" != "" ]; then
    echo "$shell_icon"
  else
    echo "$default_shell_icon"
  fi
}

SHELL_ICON=$(get_shell_icon)

get_icon() {
  case $NAME in
  tmux)
    echo ""
    ;;
   top | htop | btm | btop)
    echo ""
    ;;
   bash | zsh | tcsh | fish)
    echo "$SHELL_ICON"
    ;;
  ssh | sshpass)
    echo ""
    ;;
  vi | vim | nvim | lvim | cvim)
    echo ""
    ;;
  lazygit | git | tig | gitui)
    echo ""
    ;;
  gcc | clang)
    echo "󰎙"
    ;;
  node)
    echo "󰎙"
    ;;
  ruby)
    echo ""
    ;;
  java | javac)
    echo ""
    ;;
  go)
    echo ""
    ;;
  lf | lfcd | yazi)
    echo ""
    ;;
  beam | beam.smp) # Erlang runtime
    echo ""
    ;;
  rustc | rustup | cargo)
    echo ""
    ;;
  Python | python3 | Python3 | python | pip | pip3)
    echo ""
    ;;
  docker | lazydocker)
    echo ""
    ;;
  kubectl)
    echo "󱃾"
    ;;
  *)
    echo "󱕷"
    ;;
  esac
}

echo $(get_icon)