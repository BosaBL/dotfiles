#!/usr/bin/env bash

sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf -y copr enable solopasha/hyprland
sudo dnf -y copr enable erikreider/SwayNotificationCenter
sudo dnf -y group update core
sudo dnf -y update
sudo dnf -y upgrade --refresh
