#!/usr/bin/env bash

set -e
source bootstrap-devbox

# note: this script requires the following dependencies to be installed first:
# - install-docker.sh

# check installed version
if ! installed docker-compose; then
  installed_version=''
  echo ">> Docker-compose is not installed, installing"
else
  installed_version="$(docker-compose --version | grep -Po '\K\d+\.\d+\.\d+')"
  echo ">> Installed docker-compose version: ${installed_version}"
fi

# get latest version
latest_version="$(curl -sS https://api.github.com/repos/docker/compose/releases/latest | jq .name -r && :)"
if [[ -z "${latest_version}" ]]; then
  echo ">> Unable to get latest version of docker-compose" >/dev/stderr
  exit 1
fi
echo ">> Latest docker-compose version: ${latest_version}"

# install docker-compose if not installed or version is outdated
if [[ -z "${installed_version}" ]] || verlt "${installed_version}" "${latest_version}"; then
  echo ">> Installing docker-compose ${latest_version}"

  output='/usr/local/bin/docker-compose'
  sudo curl -sSL "https://github.com/docker/compose/releases/download/${latest_version}/docker-compose-$(uname -s)-$(uname -m)" -o "${output}"
  sudo chmod +x "${output}"

  docker-compose --version
fi
