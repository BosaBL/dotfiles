#!/usr/bin/env bash

source "$DF_SCRIPT_DIR/helpers.sh"

sudo dnf -y install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
  "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
sudo dnf -y copr enable solopasha/hyprland
sudo dnf -y copr enable erikreider/SwayNotificationCenter

sudo dnf -y update --refresh

sudo dnf install dnf-plugins-core
sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo dnf -y install brave-browser
