#!/usr/bin/env bash

source "$DF_SCRIPT_DIR/helpers.sh"

if which 'nwg-look' >/dev/null; then
  echo "ngw-look already installed"
  exit 1
fi

cd "$DF_TMP_DIR" || exit
git clone https://github.com/nwg-piotr/nwg-look.git
cd nwg-look || exit
make build
sudo make install
