#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/scripts/helpers.sh"

command_icon="#($CURRENT_DIR/scripts/command_icon.sh #{pane_current_command})"
command_icon_interpolation="\#{command_icon}"

do_interpolation() {
  local output="$1"
  local output="${output/$command_icon_interpolation/$command_icon}"
  echo "$output"
}

update_tmux_option() {
  local option="$1"
  local option_value="$(get_tmux_option "$option")"
  local new_option_value="$(do_interpolation "$option_value")"
  set_tmux_option "$option" "$new_option_value"
}

main() {
  update_tmux_option "status-right"
  update_tmux_option "status-left"
}
main