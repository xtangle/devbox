#!/usr/bin/env bash

set -e

if [[ -f ${HOME}/.nvm/nvm.sh ]]; then
  . ${HOME}/.nvm/nvm.sh
fi

if ! installed nvm; then
  installed_version=''
else
  installed_version="$(nvm --version)"
fi

latest_version="$(wget -q -O- https://github.com/creationix/nvm/releases/latest | grep -m1 '/tag/' | sed -n 's/.*<a[^>]*>v\(.*\)<\/a>.*/\1/p')"
if [[ -z "${latest_version}" ]]; then
  echo "Unable to get latest version of nvm" > /dev/stderr
  exit 1
fi

# install nvm if not installed or version is outdated
if [[ -z "${installed_version}" ]] || verlt "${installed_version}" "${latest_version}"; then
  wget -qO- "https://raw.githubusercontent.com/creationix/nvm/v${latest_version}/install.sh" | bash
  . ${HOME}/.nvm/nvm.sh

  # install latest version of node and npm
  nvm install node --latest-npm --no-progress 2>/dev/null
  # install yarn
  npm install -g yarn
fi
