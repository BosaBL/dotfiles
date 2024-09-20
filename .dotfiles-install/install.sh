#!/usr/bin/env bash

trap 'exit 130' INT

LOG_FILE="install-$(date +%d-%H%M%S).log"
TMP_DIR="$HOME/Downloads/tmp"
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

chmod +x "$SCRIPT_DIR"/helpers.sh
chmod +x "$SCRIPT_DIR"/modules/*

source "$SCRIPT_DIR"/helpers.sh

nvidiaFlag=""
yes_or_no "Do you want to install Nvidia drivers?" nvidiaFlag

echo "Appending DNF parallel downloads"
grep -qxF 'max_parallel_downloads=20' /etc/dnf/dnf.conf || echo 'max_parallel_downloads=20' | sudo tee -a /etc/dnf/dnf.conf >/dev/null

source "$SCRIPT_DIR"/modules/rpmfusion-copr.sh

if [ "$nvidiaFlag" == "Y" ]; then
  source "$SCRIPT_DIR"/modules/nvidia.sh
fi

source "$SCRIPT_DIR"/modules/packages.sh
source "$SCRIPT_DIR"/modules/kdeconnect.sh
source "$SCRIPT_DIR"/modules/sddm.sh
source "$SCRIPT_DIR"/modules/multimedia.sh
source "$SCRIPT_DIR"/modules/zsh.sh

mkdir -p "$TMP_DIR"
cd "$TMP_DIR" || exit

# These need a new shell instance
echo "Ngw-look"
"$SCRIPT_DIR"/modules/ngwlook.sh
echo "Installing Themes"
"$SCRIPT_DIR"/modules/themes.sh
echo "Installing Fonts"
"$SCRIPT_DIR"/modules/nerdfonts.sh
echo "Installing Dotfiles"
"$SCRIPT_DIR"/modules/installdotfiles.sh
echo "Dotfiles Installed"

cd "$HOME" || exit
rm -rfd "$TMP_DIR"
echo "Cleaning up"
