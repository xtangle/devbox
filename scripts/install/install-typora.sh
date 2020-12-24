#!/usr/bin/env bash

set -e
source bootstrap-devbox

# or use
# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BA300B7755AFCFAE
wget -qO- https://typora.io/linux/public-key.asc | sudo apt-key add -

# add Typora's repository
sudo -E add-apt-repository -y 'deb https://typora.io/linux ./'
sudo -E apt-get -qy update

# install Typora
sudo -E apt-get -qy install typora
