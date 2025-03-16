#!/usr/bin/env bash

mkdir -p $HOME/Downloads/tmp
cd $HOME/Downloads/tmp

DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
curl -OL "$DOWNLOAD_URL"
# Check if the JetBrainsMono folder exists and delete it if it does
if [ -d ~/.local/share/fonts/JetBrainsMonoNerd ]; then
    rm -rf ~/.local/share/fonts/JetBrainsMonoNerd
fi
mkdir -p ~/.local/share/fonts/JetBrainsMonoNerd
tar -xJkf JetBrainsMono.tar.xz -C ~/.local/share/fonts/JetBrainsMonoNerd 2>&1 | tee -a "$LOG"

fc-cache -v
