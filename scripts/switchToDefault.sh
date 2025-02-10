#!/bin/bash
pkill i3
pkill marco
pkill picom
marco &
disown
dconf reset /org/mate/desktop/session/required-components/windowmanager
dconf reset /org/mate/desktop/background/show-desktop-icons
