source "$DF_SCRIPT_DIR/helpers.sh"

packages=(
  networkmanager
  network-manager-applet
)

installPackages "${packages[@]}"

sudo systemctl enable --now NetworkManager
