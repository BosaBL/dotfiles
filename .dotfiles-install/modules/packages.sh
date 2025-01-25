#!/usr/bin/env bash

source "$DF_SCRIPT_DIR/helpers.sh"
sudo pacman -Rsc $(pacman -Qsq '^xdg-desktop-portal*')

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
  hyprland
  xdg-desktop-portal-hyprland
  pipewire
  wireplumber
  grim
  slurp
  #Pipewire
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
  imagemagick
  inxi
  jq
  kitty
  kvantum
  nano
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
  NetworkManager
  zsh
)

installPackages "${packages[@]}"

echo "Installing pyenv"
curl https://pyenv.run | bash
