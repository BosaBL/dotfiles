#!/usr/bin/env bash

git clone --bare https://github.com/bosabl/dotfiles "$HOME/.cfg"
function config {
  /usr/bin/git "--git-dir=$HOME/.cfg/" "--work-tree=$HOME" "$@"
}

# Enable sparse checkout for no checking out certain files
config core.sparsecheckout true

# Do not checkout README.md
echo README.md >>.git/info/sparse-checkout

if config checkout; then
  echo "Dotfiles Installed"
else
  echo "Backing up pre-existing dot files."
  mkdir -p .config-backup
  config checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs -I{} mv {} .config-backup/{}
  config checkout --force
fi

config config status.showUntrackedFiles no
echo "Dotfiles Installed"
