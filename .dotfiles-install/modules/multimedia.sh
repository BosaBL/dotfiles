#!/usr/bin/env bash

source "$DF_SCRIPT_DIR/helpers.sh"

packages=(
  gstreamer
)

installPackages "${packages[@]}"
