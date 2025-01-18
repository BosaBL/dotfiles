#!/usr/bin/env bash

trap 'exit 130' INT

git clone --bare https://github.com/bosabl/dotfiles "$HOME/.cfg"
function config {
  /usr/bin/git "--git-dir=$HOME/.cfg/" "--work-tree=$HOME" "$@"
}

# Enable sparse checkout for no checking out certain files
config core.sparsecheckout true

# Do not checkout README.md
echo README.md >>.git/info/sparse-checkout

if ! config checkout; then
  echo "Backing up pre-existing dot files."
  mkdir -p .config-backup
  config checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs -I{} mv {} .config-backup/{}
fi

config checkout --force

config config status.showUntrackedFiles no
echo "Dotfiles Installed"

export DF_SCRIPT_DIR="$HOME/.dotfiles-install"
export DF_LOG_DIR="$HOME/.dotfiles-install/logs"
export DF_TMP_DIR="/tmp/dotfiles-install"
DF_LOG_FILE="$DF_LOG_DIR/install-$(date +%d-%H%M%S).log"
export DF_LOG_FILE

mkdir -p "$DF_TMP_DIR" || exit 1
mkdir -p "$DF_LOG_DIR" || exit 1
touch "$DF_LOG_FILE" || exit 1

chmod +x "$DF_SCRIPT_DIR"/helpers.sh
chmod +x "$DF_SCRIPT_DIR"/modules/*

source "$DF_SCRIPT_DIR/helpers.sh"

nvidiaFlag=""
yes_or_no "Do you want to install Nvidia drivers?" nvidiaFlag

echo "Appending DNF parallel downloads"
grep -qxF 'max_parallel_downloads=20' /etc/dnf/dnf.conf || echo 'max_parallel_downloads=20' | sudo tee -a /etc/dnf/dnf.conf >/dev/null

"$DF_SCRIPT_DIR"/modules/rpmfusion-copr.sh

if [ "$nvidiaFlag" == "Y" ]; then
  source "$DF_SCRIPT_DIR"/modules/nvidia.sh
fi

/modules/packages.sh
/modules/kdeconnect.sh
/modules/sddm.sh
/modules/multimedia.sh
/modules/zsh.sh

echo "Installing Themes"
"$DF_SCRIPT_DIR"/modules/themes.sh
echo "Installing Fonts"
"$DF_SCRIPT_DIR"/modules/nerdfonts.sh

echo "Installing Ngw-look"
"$DF_SCRIPT_DIR"/modules/ngwlook.sh

rm -rfd "$DF_TMP_DIR"
echo "Cleaning up"

restartFlag=""
yes_or_no "Full restart is recommended, would you to?" restartFlag
if [ "$restartFlag" == "Y" ]; then
  sudo systemctl reboot
fi
