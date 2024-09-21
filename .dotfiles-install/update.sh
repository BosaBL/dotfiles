while true; do
  read -rp "Updating dotfiles will overwrite any local change you have made. Do u want to continue? (y/n): " answer
  case $answer in
  [Yy]*) break ;;
  [Nn]*) exit ;;
  *) echo "Please answer yes or no." ;;
  esac
done

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

function config {
  /usr/bin/git "--git-dir=$HOME/.cfg/" "--work-tree=$HOME" "$@"
}

if ! config pull; then
  echo "Pulling config"
  config reset --hard HEAD
  config pull
fi

if ! config checkout; then
  echo "Backing up pre-existing dot files."
  rm -rfd .config-backup
  mkdir -p .config-backup
  config checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs -I{} mv {} .config-backup/{}
fi

config checkout --force

echo "Dotfiles updated"
echo "Checking for new packages"

source "$SCRIPT_DIR"/helpers.sh
source "$SCRIPT_DIR"/modules/packages.sh
source "$SCRIPT_DIR"/modules/sddm.sh
source "$SCRIPT_DIR"/modules/multimedia.sh
source "$SCRIPT_DIR"/modules/zsh.sh

echo "Update finished"
