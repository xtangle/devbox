#!/usr/bin/env bash

set -e

# There was a problem with Ubuntu 18.04 where the mouse wheel won't register while the mouse cursor is moving.
# The bug seems to be in the libinput driver, and switching the pointer driver to evdev seems to solve the problem.
# See https://forums.virtualbox.org/viewtopic.php?f=3&t=79002#p401248

# update 1: see https://forums.virtualbox.org/viewtopic.php?f=3&t=79002&sid=56b23a50a361230431d5e3ab66352701&start=15#p447951

# install the evdev pointer drivers (which should override libinput)
sudo -E apt-get -qy install xserver-xorg-core-hwe-18.04 xserver-xorg-input-evdev-hwe-18.04
