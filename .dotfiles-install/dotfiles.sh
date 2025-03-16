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

"$DF_SCRIPT_DIR"/modules/yay.sh
source "$DF_SCRIPT_DIR/helpers.sh"

nvidiaFlag=""
bluetoothFlag=""
networkManager=""

yes_or_no "Do you want to install Nvidia drivers?" nvidiaFlag
yes_or_no "Do you want to enable Bluetooth support?" bluetoothFlag
yes_or_no "Do you want to swap systemd-networkd for NetworkManager" networkManager

mkdir -p "$HOME"/{Documents/{,University},Projects,Playground} || exit 1

if [ "$nvidiaFlag" == "Y" ]; then
  "$DF_SCRIPT_DIR"/modules/nvidia.sh
fi
"$DF_SCRIPT_DIR"/modules/packages.sh
if [ "$networkManager" == "Y" ]; then
  "$DF_SCRIPT_DIR"/modules/network.sh
fi
"$DF_SCRIPT_DIR"/modules/fonts.sh
"$DF_SCRIPT_DIR"/modules/sddm.sh
"$DF_SCRIPT_DIR"/modules/multimedia.sh
if [ "$bluetoothFlag" == "Y" ]; then
  "$DF_SCRIPT_DIR"/modules/bluetooth.sh
fi
"$DF_SCRIPT_DIR"/modules/zsh.sh
"$DF_SCRIPT_DIR"/modules/themes.sh

rm -rfd "$DF_TMP_DIR"
echo "Cleaning up"
