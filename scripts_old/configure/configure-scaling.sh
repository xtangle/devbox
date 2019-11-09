#!/usr/bin/env bash

set -e

load_provision_vars

# configure scaling only for high resolution
if [[ ${PROVISION_DISPLAY_WIDTH} -le 2560 ]]; then
  echo ">> Display width is ${PROVISION_DISPLAY_WIDTH}, no need to configure scaling"
  exit 0
fi

echo ">> Display width is ${PROVISION_DISPLAY_WIDTH}, configuring scaling"

# configure global dpi
backup "${HOME}/.Xresources"
cp -f "${DEVBOX_FILES}/X/.Xresources" "${HOME}"

# configure dpi on greeter screen
backup /usr/share/lightdm/lightdm-gtk-greeter.conf.d/01_ubuntu.conf
sudo sed -i -E 's/(xft-dpi)=.*/\1=200/' /usr/share/lightdm/lightdm-gtk-greeter.conf.d/01_ubuntu.conf

# configure icon sizes in file manager
sed -i -E \
  -e 's/(big_icon_size)=.*/\1=72/' \
  -e 's/(small_icon_size)=.*/\1=36/' \
  -e 's/(pane_icon_size)=.*/\1=24/' \
  -e 's/(thumbnail_size)=.*/\1=192/' \
  "${HOME}/.config/libfm/libfm.conf"

# configure sizes in lxpanel
sed -i -E \
  -e '0,/\s*height=/s/(height)=.*/\1=42/' \
  -e '0,/\s*iconsize=/s/(iconsize)=.*/\1=42/' \
  -e '0,/\s*MaxTaskWidth=/s/(MaxTaskWidth)=.*/\1=400/' \
  "${HOME}/.config/lxpanel/Lubuntu/panels/panel"
