#!/usr/bin/env bash

cd $HOME/Downloads/tmp

git clone https://github.com/nwg-piotr/nwg-look.git
cd nwg-look
make build
sudo make install
