#!/usr/bin/env bash

set -e

if ! installed sbt; then
  echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
  sudo -E apt-get -qy update
fi
sudo -E apt-get -qy install sbt
