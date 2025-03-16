#!/usr/bin/env bash

source "$DF_SCRIPT_DIR/helpers.sh"

if [ ! -d "$HOME"/.local/share/icons ]; then
  mkdir -p "$HOME"/.local/share/icons
fi

echo "Installing cursors"
tar -xzvf "$HOME"/.dotfiles-install/assets/cursors.tar.gz -C "$HOME/.local/share/icons"
sudo cp -r "$HOME"/.local/share/icons/Bibata/ /usr/share/icons/

echo "Installing themes"

cd DF_TMP_DIR || exit 1

git clone https://github.com/vinceliuice/Orchis-kde
git clone https://github.com/vinceliuice/Orchis-theme
git clone https://github.com/vinceliuice/Tela-circle-icon-theme

echo "Installing Orchis-kde"
cd Orchis-kde || exit 1
./install.sh

echo "Installing Orchis-theme"
cd ..
cd Orchis-theme || exit 1
./install.sh

echo "Installing Tela-circle-icon-theme"
cd ..
cd Tela-circle-icon-theme || exit 1
./install.sh blue
