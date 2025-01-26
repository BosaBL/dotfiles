#!/usr/bin/env bash

export DF_SCRIPT_DIR="$HOME/.dotfiles-install"
export DF_LOG_DIR="$HOME/.dotfiles-install/logs"
export DF_TMP_DIR="/tmp/dotfiles-install"
DF_LOG_FILE="$DF_LOG_DIR/install-$(date +%d-%H%M%S).log"
export DF_LOG_FILE
sudo mkdir -p "$DF_TMP_DIR" || exit 1
sudo mkdir -p "$DF_LOG_DIR" || exit 1
sudo touch "$DF_LOG_FILE" || exit 1

chmod +x "$DF_SCRIPT_DIR"/helpers.sh
chmod +x "$DF_SCRIPT_DIR"/modules/*

"$DF_SCRIPT_DIR"/modules/yay.sh
source "$DF_SCRIPT_DIR/helpers.sh"

nvidiaFlag=""
yes_or_no "Do you want to install Nvidia drivers?" nvidiaFlag
bluetoothFlag=""
yes_or_no "Do you want to enable Bluetooth support?" nvidiaFlag

mkdir -p "$HOME"/{Documents/{,University},Projects,Playground} || exit 1

if [ "$nvidiaFlag" == "Y" ]; then
  "$DF_SCRIPT_DIR"/modules/nvidia.sh
fi

if [ "$bluetoothFlag" == "Y" ]; then
  "$DF_SCRIPT_DIR"/modules/bluetooth.sh
fi

"$DF_SCRIPT_DIR"/modules/packages.sh
"$DF_SCRIPT_DIR"/modules/network.sh
"$DF_SCRIPT_DIR"/modules/fonts.sh
"$DF_SCRIPT_DIR"/modules/sddm.sh
"$DF_SCRIPT_DIR"/modules/multimedia.sh
"$DF_SCRIPT_DIR"/modules/zsh.sh
"$DF_SCRIPT_DIR"/modules/themes.sh

rm -rfd "$DF_TMP_DIR"
echo "Cleaning up"

# Check for nvidia driver successful instalation and then suggest to restart
echo "Checking for successful nvidia driver installation..."
while true; do
  sleep 1
  if ! modinfo -F version nvidia; then
    continue
  fi
  echo "Nvidia driver has been successfully installed."

  restartFlag=""
  yes_or_no "Full restart is recommended, would you like to?" restartFlag
  if [ "$restartFlag" == "Y" ]; then
    sudo systemctl reboot
  fi
  break
done
