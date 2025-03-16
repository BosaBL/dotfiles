#!/usr/bin/env bash

packages=(
    curl
    golang
    python3
    python3-pip
    gawk
    btop
    ImageMagick
    git
    gh
    hyprland
    pipewire
    wireplumber
    xdg-desktop-portal-hyprland
    polkit-kde
    qt5ct
    qt6ct
    qt6-qtsvg
    qt5-qtwayland
    qt6-qtwayland
    waybar
    swww
    hyprpicker
    kvantum
    network-manager-applet
    openssl
    wlogout
    nvtop
    btop
    fastfetch
    qalculate-gtk
    pamixer
    pavucontrol
    pipewire-alsa
    pipewire-utils
    playerctl
    SwayNotificationCenter
    aylurs-gtk-shell
    nvtop
    # texlive-scheme-full
    bat
    fzf
    zoxide
    eza
    jetbrains-mono-fonts
    pyprland
    gtk3
    gtk3-devel
    cairo-devel
    glib-devel
    gnome-themes-extra
    gtk-murrine-engine
    sassc
    dolphin
    okular
    # xdg-desktop-portal-gtk
    neovim
    brave-browser
    pam-kwallet
    rofi-wayland
)


installPackages "${packages[@]}"

echo "Installing pyenv"
curl https://pyenv.run | bash
