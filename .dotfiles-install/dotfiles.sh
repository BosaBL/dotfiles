#!/usr/bin/env bash

export DF_SCRIPT_DIR="$HOME/.dotfiles-install"
export DF_LOG_DIR="$HOME/.dotfiles-install/logs"
export DF_TMP_DIR="/tmp/dotfiles-install"
DF_LOG_FILE="$DF_LOG_DIR/install-$(date +%d-%H%M%S).log"
export DF_LOG_FILE
mkdir -p "$DF_TMP_DIR" || exit 1
mkdir -p "$DF_LOG_DIR" || exit 1
touch "$DF_LOG_FILE" || exit 1

chmod +x "$DF_SCRIPT_DIR"/helpers.sh
chmod +x "$DF_SCRIPT_DIR"/modules/*

source "$DF_SCRIPT_DIR/helpers.sh"

mkdir -p "$HOME"/{Documents/{,University},Projects,Playground} || exit 1

"$DF_SCRIPT_DIR"/modules/packages.sh
"$DF_SCRIPT_DIR"/modules/kdeconnect.sh
"$DF_SCRIPT_DIR"/modules/sddm.sh
"$DF_SCRIPT_DIR"/modules/multimedia.sh
"$DF_SCRIPT_DIR"/modules/zsh.sh

echo "Installing Themes"
"$DF_SCRIPT_DIR"/modules/themes.sh

rm -rfd "$DF_TMP_DIR"
echo "Cleaning up"
