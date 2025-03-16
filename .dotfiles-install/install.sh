#!/usr/bin/env bash

LOG_FILE="install-$(date +%d-%H%M%S).log"

chmod +x ./helpers.sh
chmod +x ./modules/*

nvidiaFlag=""

echo "Appending DNF Line"
grep -qxF 'max_parallel_downloads=20' /etc/dnf/dnf.conf || sudo echo 'max_parallel_downloads=20' >> /etc/dnf/dnf.conf

# These need to be sourced since they are not standalone scripts
source ./helpers.sh

yes_or_no "Do you want to install Nvidia drivers?" nvidiaFlag

# These need to be sourced since they are not standalone scripts
source ./modules/rpmfusion-copr.sh

if [ "$nvidiaFlag" == "Y" ]; then
    source ./modules/nvidia.sh
fi

source ./modules/packages.sh
source ./modules/kdeconnect.sh
source ./modules/sddm.sh
source ./modules/multimedia.sh

mkdir -p $HOME/Downloads/tmp

# These just need to be executed, they are standalone script
echo "Ngw-look"
./modules/ngwlook.sh
echo "Installing ZSH"
./modules/zsh.sh
echo "Installing Themes"
./modules/themes.sh
echo "Installing Fonts"
./modules/nerdfonts.sh
echo "Installing Dotfiles"
./modules/installdotfiles.sh
echo "Dotfiles Installed"
echo "Cleaning up"

rm -rfd $HOME/Downloads/tmp
