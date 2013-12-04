#!/bin/bash

# useful tools
sudo apt-get -ym install wget

# install dependencies
sudo apt-get -ym install git
# install bazaar from latest package
wget http://ftp.us.debian.org/debian/pool/main/b/bzr/python-bzrlib_2.6.0~bzr6526-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/b/bzr/bzr_2.6.0~bzr6526-1_all.deb
wget http://ftp.us.debian.org/debian/pool/main/b/bzr/python-bzrlib_2.6.0-3_amd64.deb
sudo dpkg -i python-bzrlib_2.6.0~bzr6526-1_amd64.deb
sudo dpkg -i bzr_2.6.0~bzr6526-1_all.deb
sudo dpkg -i python-bzrlib_2.6.0-3_amd64.deb
sudo apt-get -f -y install

# install git-remote-bzr
sudo wget https://raw.github.com/felipec/git/fc/master/git-remote-bzr.py -O /usr/local/bin/git-remote-bzr

# install git-bzr-merge
sudo cp git-bzr-merge /usr/local/bin/

# install bats (unit tests)
git clone https://github.com/sstephenson/bats.git
cd bats
sudo ./install.sh /usr/local
cd ..

# define bzr/git user
bzr whoami "Travis <robot@travis-ci.org>"
git config --global user.email "robot@travis-ci.org"
git config --global user.name "Travis"

