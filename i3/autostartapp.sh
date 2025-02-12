#!/bin/bash

# Returns the number of windows in the given workspace.
workspace_window_count() {
    local ws_name="$1"
    i3-msg -t get_tree | jq --arg ws "$ws_name" '
      (recurse(.nodes[]?) |
       select(.type=="workspace" and .name==$ws) |
       .nodes | map(select(.window != null)) | length)
      // 0
    '
}

# Accept a workspace argument, defaulting to 8 if none is provided.
workspace_to_check="${1:-8}"

if [ "$(workspace_window_count "$workspace_to_check")" -eq 0 ]; then
  if [ "$workspace_to_check" -eq 4 ]; then
    snap run postman &
  fi
  if [ "$workspace_to_check" -eq 8 ]; then
    google-chrome --app=http://192.168.1.146:8123 &
  fi
  if [ "$workspace_to_check" -eq 9 ]; then
    spotify &
  fi
fi

