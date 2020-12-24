#!/usr/bin/env bash

set -e
source bootstrap-devbox

# dev tools
sudo -E apt-get -qy install vim shellcheck dos2unix

# OS customization tools
sudo -E apt-get -qy install gparted arandr gnome-tweak-tool
flatpak install -y --noninteractive flathub com.github.tchx84.Flatseal
