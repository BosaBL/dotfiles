source "$DF_SCRIPT_DIR/helpers.sh"

packages=(
  networkmanager
  network-manager-applet
)

installPackages "${packages[@]}"

# Enable NetworkManager service
sudo systemctl enable --now NetworkManager

# Disable systemd-networkd
sudo systemctl stop NetworkManager.service
sudo systemctl disable NetworkManager.service
