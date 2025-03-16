#!/usr/bin/env bash

source "$DF_SCRIPT_DIR/helpers.sh"

packages=(
  # Fonts
  noto-fonts
  ttf-jetbrains-mono
  ttf-jetbrains-mono-nerd
  otf-font-awesome
  ttf-droid
  ttf-fira-code
  adobe-source-code-pro-fonts
)

installPackages "${packages[@]}"
