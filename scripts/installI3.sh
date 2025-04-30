#!/bin/bash

# Check if the current desktop environment is MATE
if [[ "$XDG_CURRENT_DESKTOP" != "MATE" ]]; then
  echo "This script is intended to be run on Ubuntu MATE. Current desktop: $XDG_CURRENT_DESKTOP"
  exit 1
fi

# Installs i3 on ubuntu mate 24.04
sudo apt install i3
sudo apt remove dunst
sudo apt install picom
sudo apt install dconf-editor

dconf write /org/mate/desktop/session/required-components/windowmanager "'i3'"
dconf write /org/mate/desktop/background/show-desktop-icons false

# If you have WIN as your i3 modifier(SUPER) and brisk-menu as your applet, you will have bad experience with i3wm.
# dconf reset /com/solus-project/brisk-menu/hot-key
dconf write /com/solus-project/brisk-menu/hot-key "''"

LIGHT_GREEN='\e[38;2;195;232;120m'  # RGB color (a light green)
echo -e "${LIGHT_GREEN}Log out and log back in for i3 to work\033[0m"


