#!/usr/bin/env bash

if which 'nwg-look' >/dev/null; then
  echo "ngw-look already installed"
  exit 1
fi

git clone https://github.com/nwg-piotr/nwg-look.git
cd nwg-look || exit
make build
sudo make install
