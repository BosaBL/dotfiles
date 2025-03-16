#!/usr/bin/env bash

LOG_FILE="install-$(date +%d-%H%M%S).log"
TMP_DIR="$HOME/Downloads/tmp"
chmod +x ./helpers.sh
chmod +x ./modules/*

nvidiaFlag=""
yes_or_no "Do you want to install Nvidia drivers?" nvidiaFlag

echo "Appending DNF parallel downloads"
grep -qxF 'max_parallel_downloads=20' /etc/dnf/dnf.conf || echo 'max_parallel_downloads=20' | sudo tee -a /etc/dnf/dnf.conf >/dev/null

source ./helpers.sh
source ./modules/rpmfusion-copr.sh

if [ "$nvidiaFlag" == "Y" ]; then
  source ./modules/nvidia.sh
fi

source ./modules/packages.sh
source ./modules/kdeconnect.sh
source ./modules/sddm.sh
source ./modules/multimedia.sh
source ./modules/zsh.sh

mkdir -p "$TMP_DIR"
cd "$TMP_DIR" || exit

# These need a new shell instance
echo "Ngw-look"
./modules/ngwlook.sh
echo "Installing Themes"
./modules/themes.sh
echo "Installing Fonts"
./modules/nerdfonts.sh
echo "Installing Dotfiles"
./modules/installdotfiles.sh
echo "Dotfiles Installed"

cd "$HOME" || exit
rm -rfd "$TMP_DIR"
echo "Cleaning up"
