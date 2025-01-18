#!/usr/bin/env bash

source "$DF_SCRIPT_DIR/helpers.sh"

packages=(
  akmod-nvidia
  xorg-x11-drv-nvidia-cuda
  xorg-x11-drv-nvidia-cuda-libs
  nvidia-vaapi-driver
  libva-utils
  vdpauinfo
  xorg-x11-drv-nvidia-power
)

installPackages "${packages[@]}"
sudo systemctl enable nvidia-{suspend,resume,hibernate}
