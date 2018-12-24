#!/usr/bin/env bash

set -e

# uninstall light-locker
sudo -E apt-get -qq remove light-locker
sudo -E apt-get -qq autoremove

# disable lock screen and screensaver
cp -f ${vagrant_files}/X/.xscreensaver ${HOME}
