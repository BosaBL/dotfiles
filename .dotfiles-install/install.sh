#!/usr/bin/env bash

trap ctrl_c INT
function ctrl_c() {
  exit
}

# Initiate global env vars for the installation script
export DF_SCRIPT_DIR="$HOME/.dotfiles-install"
export DF_LOG_DIR="$HOME/.dotfiles-install/logs"
export DF_TMP_DIR="/tmp/dotfiles-install"
DF_LOG_FILE="$DF_LOG_DIR/install-$(date +%d-%H%M%S).log"
export DF_LOG_FILE
mkdir -p "$DF_TMP_DIR" || exit 1
mkdir -p "$DF_LOG_DIR" || exit 1
touch "$DF_LOG_FILE" || exit 1

# Download dotfiles
git clone --bare https://github.com/bosabl/dotfiles "$HOME/.cfg"
function config {
  /usr/bin/git "--git-dir=$HOME/.cfg/" "--work-tree=$HOME" "$@"
}
# Enable sparse checkout for no checking out certain files
config config core.sparsecheckout true

# Do not checkout README.md
echo README.md >>"$HOME"/.cfg/info/sparse-checkout

if ! config checkout; then
  echo "Backing up pre-existing dot files."
  mkdir -p .config-backup
  config checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs -I{} mv {} .config-backup/{}
fi
config checkout --force
config config status.showUntrackedFiles no
echo "Dotfiles downloaded"

# Main script to execute
"$DF_SCRIPT_DIR"/dotfiles.sh

config checkout --force

# Check for nvidia driver successful instalation and then suggest to restart
echo "Checking for successful nvidia driver installation..."
while 1; do
  sleep 1
  if modinfo -F version nvidia; then
    continue
  fi
  echo "Nvidia driver has been successfully installed."

  restartFlag=""
  yes_or_no "Full restart is recommended, would you like to?" restartFlag
  if [ "$restartFlag" == "Y" ]; then
    sudo systemctl reboot
  fi
  break
done
