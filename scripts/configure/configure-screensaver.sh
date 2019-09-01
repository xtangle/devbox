#!/usr/bin/env bash

set -e

# uninstall light-locker and xscreensaver
sudo -E apt-get -qy remove light-locker xscreensaver
sudo -E apt-get -qy autoremove

# disable power management and screensaver
backup "${HOME}/.xsessionrc"
cp -f "${DEVBOX_FILES}/X/.xsessionrc" "${HOME}"
