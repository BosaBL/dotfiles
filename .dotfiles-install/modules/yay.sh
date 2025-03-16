#!/usr/bin/env bash
source "$DF_SCRIPT_DIR/helpers.sh"

packages=(
  base-devel
  git
)

installPackages "${packages[@]}"

cd "$DF_TMP_DIR" || exit

git clone https://aur.archlinux.org/yay.git
cd yay || exit
makepkg -si
