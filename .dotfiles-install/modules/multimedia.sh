#!/usr/bin/env bash

source "$DF_SCRIPT_DIR/helpers.sh"

sudo dnf -y swap 'ffmpeg-free' 'ffmpeg' --allowerasing
sudo dnf -y group install Multimedia
sudo dnf -y update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf -y update @sound-and-video

sudo dnf -y install ffmpeg-libs libva libva-utils
sudo dnf -y swap libva-intel-media-driver intel-media-driver --allowerasing
sudo dnf -y install libva-intel-driver
