#!/usr/bin/env bash

source "$DF_SCRIPT_DIR/helpers.sh"

packages=(
  #Kde Apps
  dolphin
  kwallet
  kwalletmanager
  kwallet-pam
  okular
  #Themes
  unzip
  gtk-engine-murrine
  #Hyprland
  hyprcursor
  hyprutils
  aquamarine
  hypridle
  hyprlock
  hyprland
  pyprland
  hyprlandqutils
  #Pipewire
  pipewire
  wireplumber
  pipewire-audio
  pipewire-alsa
  pipewire-pulse
  sof-firmware
  bat
  #Bluetooth
  bluez
  bluez-utils
  blueman
  #Extras
  neovim
  cliphist
  curl
  grim
  gvfs
  gvfs-mtp
  hyprpolkitagent
  imagemagick
  inxi
  jq
  kitty
  kvantum
  nano
  network-manager-applet
  pamixer
  pavucontrol
  pipewire-alsa
  playerctl
  python-requests
  python-pyquery
  qt5ct
  qt6ct
  qt6-svg
  rofi-wayland
  slurp
  swappy
  swaync
  swww
  wallust
  waybar
  wget
  wl-clipboard
  wlogout
  xdg-user-dirs
  xdg-utils
  yad
  brightnessctl
  btop
  cava
  eog
  fastfetch
  gnome-system-monitor
  mousepad
  mpv
  mpv-mpris
  nvtop
  nwg-look
  pacman-contrib
  qalculate-gtk
  vim
  yt-dlp
  brave-bin
  sddm
)

installPackages "${packages[@]}"

echo "Installing pyenv"
curl https://pyenv.run | bash
