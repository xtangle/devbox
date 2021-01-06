#!/usr/bin/env bash

set -e
source bootstrap-devbox

# kill currently interfering processes
release_lock_file -f /var/lib/dpkg/lock-frontend
release_lock_file -f /var/lib/apt/lists/lock

# update system
sudo -E apt-get -qy update --fix-missing
sudo -E apt-get -qy dist-upgrade --fix-missing
sudo -E apt-get -qy autoremove

# install snap
sudo -E apt-get -qy install snapd
sudo -E snap refresh
sudo -E snap install snap-store

# install flatpak (by default it is installed in Pop_OS! 20.04+)
# Commented out because permissions keep getting messed up and errors about
# "No remote refs found similar to ‘flathub’" keeps happening later
sudo -E apt-get -qy install flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak repair
sudo flatpak update -y --noninteractive
sudo flatpak uninstall --unused -y --noninteractive
