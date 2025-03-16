#!/usr/bin/env bash

source "$DF_SCRIPT_DIR/helpers.sh"

sudo dnf -y swap 'ffmpeg-free' 'ffmpeg' --allowerasing
sudo dnf -y group install Multimedia
sudo dnf -y update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf -y update @sound-and-video
