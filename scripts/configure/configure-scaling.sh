#!/usr/bin/env bash

set -e

# configure scaling only for high resolution
if [[ ${display_width} -le 2560 ]]; then
  exit 0
fi

# add .Xresources to configure global dpi
backup ${HOME}/.Xresources
cp -f ${vagrant_files}/Xresources/.Xresources ${HOME}

# configure icon sizes in file manager
sed -i -E \
  -e 's/(big_icon_size)=.*/\1=72/' \
  -e 's/(small_icon_size)=.*/\1=36/' \
  -e 's/(pane_icon_size)=.*/\1=24/' \
  -e 's/(thumbnail_size)=.*/\1=192/' \
  ${HOME}/.config/libfm/libfm.conf

# configure sizes in lxpanel
sed -i -E \
  -e '0,/\s*height=/s/(height)=.*/\1=42/' \
  -e '0,/\s*iconsize=/s/(iconsize)=.*/\1=42/' \
  -e '0,/\s*MaxTaskWidth=/s/(MaxTaskWidth)=.*/\1=400/' \
  ${HOME}/.config/lxpanel/Lubuntu/panels/panel
