#!/bin/bash

# Autostarts the command if the workspace is empty

workspace_window_count() {
    local ws_name="$1"
    i3-msg -t get_tree | jq --arg ws "$ws_name" '
      (recurse(.nodes[]?, .floating_nodes[]?) |
       select(.type=="workspace" and .name==$ws) |
       recurse(.nodes[]?, .floating_nodes[]?) |
       .nodes | map(select(.window != null)) | length)
      // 0
    '
}

# Accept workspace argument, defaulting to 8 if none is provided.
workspace_to_check="${2:-8}"
command_to_run="$1" # The command to execute

window_count=$(workspace_window_count "$workspace_to_check")

# Print the workspace check result
echo "Workspace $workspace_to_check has $window_count window(s)."

# Run the command if workspace is empty
if [ "$window_count" -eq 0 ] && [ -n "$command_to_run" ]; then
  eval "$command_to_run &"
fi

