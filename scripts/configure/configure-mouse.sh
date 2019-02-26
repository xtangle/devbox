#!/usr/bin/env bash

set -e

# There was a problem with Ubuntu 18.04 where the mouse wheel won't register while the mouse cursor is moving.
# The bug seems to be in the libinput driver, and switching the pointer driver to evdev seems to solve the problem.
# See https://forums.virtualbox.org/viewtopic.php?f=3&t=79002#p401248

# install the evdev pointer driver
sudo -E apt-get -qq install xserver-xorg-input-evdev

# copy config
backup /usr/share/X11/xorg.conf.d/40-libinput.conf
sudo cp -f "${VAGRANT_FILES}/X/40-libinput.conf" /usr/share/X11/xorg.conf.d
