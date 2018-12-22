#!/usr/bin/env bash

set -e

if [[ ! -d "${HOME}/idea-IU" ]]; then
  installed_version=''
else
  installed_version="$(ls -a ${HOME} | grep '.IntelliJIdea' | sed -n 's/\.IntelliJIdea\(.*\)/\1/p')"
fi

intellij_url=$(curl -s "https://data.services.jetbrains.com/products/releases?code=IIU&latest=true&type=release" | grep -E -o "linuxWithoutJDK\":{\"link\":\"[^\"]+" | egrep -o 'https?://[^ ]+')
intellij_tar_zip_file=ideaIU-no-jdk.tar.gz
latest_version=$(echo ${intellij_url} | sed 's/.*ideaIU-\([[:digit:]]\+.[[:digit:]]\).*/\1/')
if [[ -z "${latest_version}" ]]; then
  echo "Unable to get latest version of IntelliJ" > /dev/stderr
  exit 1
fi

# install IntelliJ if not installed or version is outdated
if [[ -z "${installed_version}" ]] || verlt "${installed_version}" "${latest_version}"; then
  echo "Installing IntelliJ Ultimate ${latest_version}"
  wget -q --no-check-certificate -c -O ${intellij_tar_zip_file} ${intellij_url}
  tar -xzf ${intellij_tar_zip_file}
  rm ideaIU-*.tar.gz

  rm -rf ${HOME}/idea-IU
  mv idea-IU-* ${HOME}/idea-IU

  echo "Creating IntelliJ config directory in user home"
  mkdir -p ${HOME}/.IntelliJIdea"${latest_version}"

  # add IntelliJ to the list of text editors
  sudo update-alternatives --install /usr/bin/editor editor ${HOME}/idea-IU/bin/idea.sh 0

  # add menu entry
  mkdir -p ${HOME}/.local/share/applications
  cp -f ${vagrant_files}/Menu/jetbrains-idea.desktop ${HOME}/.local/share/applications

  # add desktop icon
  cp -f ${vagrant_files}/Desktop/jetbrains-idea.desktop ${HOME}/Desktop
fi
