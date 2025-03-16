#!/usr/bin/env bash

packages=(
  base-devel
  git
)

sudo pacman -S --needed --noconfirm "${packages[@]}"

cd "$DF_TMP_DIR" || exit

git clone https://aur.archlinux.org/yay.git
cd yay || exit
makepkg -si
