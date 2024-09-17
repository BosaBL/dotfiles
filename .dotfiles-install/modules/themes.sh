#!/usr/bin/env bash

git clone https://github.com/vinceliuice/Orchis-kde
git clone https://github.com/vinceliuice/Orchis-theme
git clone https://github.com/vinceliuice/Tela-circle-icon-theme

cd Orchis-kde || exit
./install.sh

cd ..
cd Orchis-theme || exit
./install.sh

cd ..
cd Tela-circle-icon-theme || exit
./install.sh blue
