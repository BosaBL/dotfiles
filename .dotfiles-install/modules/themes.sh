#!/usr/bin/env bash

if [ ! -d "$HOME"/.local/share/icons ]; then
  mkdir -p "$HOME"/.local/share/icons
fi

echo "Installing cursors"
tar -xzvf "$HOME"/.dotfiles-install/assets/cursors.tar.gz -C "$HOME/.local/share/icons"
sudo cp -r "$HOME"/.local/share/icons/Bibata/ /usr/share/icons/

git clone https://github.com/vinceliuice/Orchis-kde
git clone https://github.com/vinceliuice/Orchis-theme
git clone https://github.com/vinceliuice/Tela-circle-icon-theme

echo "Installing Orchis-kde"
cd Orchis-kde || exit
./install.sh

echo "Installing Orchis-theme"
cd ..
cd Orchis-theme || exit
./install.sh

echo "Installing Tela-circle-icon-theme"
cd ..
cd Tela-circle-icon-theme || exit
./install.sh blue
