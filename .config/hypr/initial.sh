#!/usr/bin/env bash

if [ -f "$HOME/.config/hypr/.initial-flag" ]; then
    exit 0
fi

swww-daemon

kvantummanager --set OrchisDark
swww img $HOME/Pictures/Wallpapers/background.png

touch $HOME/.config/hypr/.initial-flag
