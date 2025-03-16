#!/usr/bin/env bash

git clone https://github.com/nwg-piotr/nwg-look.git
cd nwg-look || exit
make build
sudo make install
