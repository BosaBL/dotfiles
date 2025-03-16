#!/usr/bin/env bash

if [ -f "$HOME/.config/hypr/.initial-flag" ]; then
    exit 0
fi

swww-daemon

nwg-look -a

kvantummanager --set OrchisDark
swww img $HOME/Pictures/Wallpapers/background.png

notify-send "Initial boot executed."
touch $HOME/.config/hypr/.initial-flag
