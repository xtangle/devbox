#!/usr/bin/env bash

set -e

# note: this script has the following dependencies: install-docker.sh

# check installed version
if ! installed docker-compose; then
  installed_version=''
else
  installed_version="$(docker-compose --version | grep -Po '\K\d+\.\d+\.\d+')"
fi

# get latest version
latest_version=$(curl -sS https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)
if [[ -z "${latest_version}" ]]; then
  echo "Unable to get latest version of docker-compose" > /dev/stderr
  exit 1
fi

# install docker-compose if not installed or version is outdated
if [[ -z "${installed_version}" ]] || verlt "${installed_version}" "${latest_version}"; then
  echo "Installing docker-compose ${latest_version}"

  output='/usr/local/bin/docker-compose'
  sudo curl -sSL https://github.com/docker/compose/releases/download/${latest_version}/docker-compose-$(uname -s)-$(uname -m) -o ${output}
  sudo chmod +x ${output}

  echo "$(docker-compose --version)"
fi
