#!/usr/bin/env bash

git clone https://github.com/vinceliuice/Orchis-kde
git clone https://github.com/vinceliuice/Orchis-theme
git clone https://github.com/vinceliuice/Tela-circle-icon-theme

cd $HOME/Downloads/tmp

cd Orchis-kde
./install.sh

cd ..
cd Orchis-theme
./install.sh

cd ..
cd Tela-circle-icon-theme
./install.sh blue
