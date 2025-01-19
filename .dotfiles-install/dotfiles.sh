#!/usr/bin/env bash

chmod +x "$DF_SCRIPT_DIR"/helpers.sh
chmod +x "$DF_SCRIPT_DIR"/modules/*

source "$DF_SCRIPT_DIR/helpers.sh"

nvidiaFlag=""
yes_or_no "Do you want to install Nvidia drivers?" nvidiaFlag

echo "Appending DNF parallel downloads"
grep qxF 'max_parallel_downloads=20' /etc/dnf/dnf.conf || echo 'max_parallel_downloads=20' | sudo tee -a /etc/dnf/dnf.conf >/dev/null

"$DF_SCRIPT_DIR"/modules/rpmfusion-copr.sh

mkdir -p "$HOME"/{Documents/{,University},Projects,Playground} || exit 1

if [ "$nvidiaFlag" == "Y" ]; then
  source "$DF_SCRIPT_DIR"/modules/nvidia.sh
fi

"$DF_SCRIPT_DIR"/modules/packages.sh
"$DF_SCRIPT_DIR"/modules/kdeconnect.sh
"$DF_SCRIPT_DIR"/modules/sddm.sh
"$DF_SCRIPT_DIR"/modules/multimedia.sh
"$DF_SCRIPT_DIR"/modules/zsh.sh

echo "Installing Themes"
"$DF_SCRIPT_DIR"/modules/themes.sh
echo "Installing Fonts"
"$DF_SCRIPT_DIR"/modules/nerdfonts.sh

echo "Installing Ngw-look"
"$DF_SCRIPT_DIR"/modules/ngwlook.sh

rm -rfd "$DF_TMP_DIR"
echo "Cleaning up"
