#!/usr/bin/env bash

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
