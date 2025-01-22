#!/usr/bin/env bash

trap ctrl_c INT
function ctrl_c() {
  exit
}

# Initiate global env vars for the installation script
export DF_SCRIPT_DIR="$HOME/.dotfiles-install"

# Download dotfiles
git clone --bare https://github.com/bosabl/dotfiles "$HOME/.cfg"
function config {
  /usr/bin/git "--git-dir=$HOME/.cfg/" "--work-tree=$HOME" "$@"
}
# Enable sparse checkout for no checking out certain files
config config core.sparsecheckout true

# Do not checkout README.md
command="/*
!README.md"

echo "$command" >>"$HOME"/.cfg/info/sparse-checkout

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
while true; do
  sleep 1
  if ! modinfo -F version nvidia; then
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
