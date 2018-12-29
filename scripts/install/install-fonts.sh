#!/usr/bin/env bash

set -e

# installs Input fonts from http://input.fontbureau.com/
if ! fc-list | contains Input-Font; then
  cd /usr/local/share/fonts
  sudo wget -q "http://input.fontbureau.com/build/?fontSelection=whole&a=0&g=0&i=0&l=0&zero=0&asterisk=0&braces=0&preset=default&line-height=1.2&accept=I+do&email=" -O Input-Font.zip
  sudo unzip -q Input-Font.zip -d Input-Font
  sudo fc-cache -f .
  sudo rm -f Input-Font.zip
fi

# installs Roboto fonts
if ! fc-list | contains Roboto-Regular; then
  cd /usr/local/share/fonts
  sudo -E apt-get -qq install fonts-roboto
  sudo fc-cache -f .
fi
