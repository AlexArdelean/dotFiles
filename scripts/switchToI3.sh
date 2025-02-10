#!/bin/bash
killall marco
pkill -9 compiz
pkill i3
i3 &
disown
dconf write /org/mate/desktop/session/required-components/windowmanager "'i3'"
dconf write /org/mate/desktop/background/show-desktop-icons false
