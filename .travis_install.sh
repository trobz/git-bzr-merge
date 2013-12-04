#!/bin/bash

# useful tools
sudo apt-get -ym install wget

# install dependencies
sudo apt-get -ym install git bzr
wget https://raw.github.com/felipec/git/fc/master/git-remote-bzr.py -O /usr/local/bin/git-remote-bzr

# install git-bzr-merge
sudo cp git-bzr-merge /usr/local/bin/

# install bats (unit tests)
git clone https://github.com/sstephenson/bats.git
cd bats
sudo ./install.sh /usr/local
cd ..