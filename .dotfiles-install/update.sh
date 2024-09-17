while true; do
  read -rp "Updating dotfiles will overwrite any local change you have made. Do u want to continue? (y/n): " answer
  case $answer in
  [Yy]*) break ;;
  [Nn]*) exit ;;
  *) echo "Please answer yes or no." ;;
  esac
done

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

  config checkout --force
else
  echo "Dotfiles updated"
fi

echo "Dotfiles updated"
echo "Checking for new packages"

source ./helpers.sh
source ./modules/packages.sh
source ./modules/sddm.sh
source ./modules/multimedia.sh
source ./modules/zsh.sh

echo "Update finished"
