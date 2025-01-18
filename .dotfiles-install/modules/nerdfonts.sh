#!/usr/bin/env bash

source "$DF_SCRIPT_DIR/helpers.sh"

cd "$DF_TMP_DIR" || exit

DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
curl -OL "$DOWNLOAD_URL"
# Check if the JetBrainsMono folder exists and delete it if it does
if [ -d ~/.local/share/fonts/JetBrainsMonoNerd ]; then
  rm -rf "$HOME/.local/share/fonts/JetBrainsMonoNerd"
fi
mkdir -p "$HOME/.local/share/fonts/JetBrainsMonoNerd"
tar -xJkf JetBrainsMono.tar.xz -C "$HOME/.local/share/fonts/JetBrainsMonoNerd" 2>&1 | tee -a "$LOG"

fc-cache -v
