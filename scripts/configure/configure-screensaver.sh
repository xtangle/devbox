#!/usr/bin/env bash

set -e

# uninstall light-locker and xscreensaver
sudo -E apt-get -qq remove light-locker xscreensaver
sudo -E apt-get -qq autoremove

# disable power management and screensaver
backup ${HOME}/.xsessionrc
cp -f ${vagrant_files}/X/.xsessionrc ${HOME}
