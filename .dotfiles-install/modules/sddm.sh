#!/usr/bin/env bash

source "$DF_SCRIPT_DIR/helpers.sh"

installPackage "sddm"

sudo cp -r "$DF_SCRIPT_DIR"/assets/sddm-astronaut-theme /usr/share/sddm/themes
sudo cp "$DF_SCRIPT_DIR"/assets/sddm.conf /etc/
sudo tar -xzvf "$DF_SCRIPT_DIR"/assets/cursors.tar.gz -C "/usr/local/share/icons/"

sudo chmod -R o+wrx /usr/share/sddm/themes/sddm-astronaut-theme

sudo systemctl set-default graphical.target
sudo systemctl enable sddm.service
