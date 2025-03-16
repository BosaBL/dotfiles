source "$DF_SCRIPT_DIR/helpers.sh"

packages=(
  NetworkManager
)

installPackages "${packages[@]}"

sudo systemctl enable --now NetworkManager
