source "$DF_SCRIPT_DIR/helpers.sh"

packages=(
  #Bluetooth
  bluez
  bluez-utils
  blueman
)

installPackages "${packages[@]}"

sudo systemctl enable --now bluetooth
