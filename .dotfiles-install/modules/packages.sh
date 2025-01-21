#!/usr/bin/env bash

source "$DF_SCRIPT_DIR/helpers.sh"

# packages=(
#   ripgrep
#   curl
#   golang
#   python3
#   python3-pip
#   gawk
#   btop
#   ImageMagick
#   git
#   gh
#   hyprland
#   pipewire
#   wireplumber
#   xdg-desktop-portal-hyprland
#   mate-polkit
#   qt5ct
#   qt6ct
#   qt6-qtsvg
#   qt5-qtwayland
#   qt6-qtwayland
#   waybar
#   swww
#   hyprpicker
#   hyprshot
#   swayidle
#   kvantum
#   network-manager-applet
#   openssl
#   wlogout
#   nvtop
#   btop
#   fastfetch
#   qalculate-gtk
#   pamixer
#   pavucontrol
#   pipewire-alsa
#   pipewire-utils
#   playerctl
#   SwayNotificationCenter
#   aylurs-gtk-shell
#   nvtop
#   # texlive-scheme-full
#   bat
#   fzf
#   zoxide
#   eza
#   jetbrains-mono-fonts
#   pyprland
#   gtk3
#   gtk3-devel
#   cairo-devel
#   glib-devel
#   kwallet
#   pam-kwallet
#   gnome-themes-extra
#   gtk-murrine-engine
#   sassc
#   dolphin
#   okular
#   xdg-desktop-portal-gtk
#   haruna
#   neovim
#   rofi-wayland
#   ark
#   ffmpegthumbs
#   kio-gdrive
#   kdegraphics-thumbnailers
#   ibm-plex-fonts-all
#   swaylock-effects
#   brave-browser
#   swappy
#   brave-browser
#   sddm
#   zsh
# )

packages=(
  # Fonts
  noto-fonts
  ttf-jetbrains-mono
  ttf-jetbrains-mono-nerd
  otf-font-awesome
  ttf-droid
  ttf-fira-code
  adobe-source-code-pro-fonts
  #KDE
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
  #Nvidia
  nvidia-settings
  libva
  libva-nvidia-driver
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
)

installPackages "${packages[@]}"

echo "Installing pyenv"
curl https://pyenv.run | bash
