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
    xdg-desktop-portal-gtk
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
    texlive-scheme-full
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
    kwallet
    pam-kwallet
    dolphin
    okular
    brave-browser
)

sudo dnf -y install dnf-plugins-core
sudo dnf -y config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

installPackages "${packages[@]}"

echo "Installing pyenv"
curl https://pyenv.run | bash
