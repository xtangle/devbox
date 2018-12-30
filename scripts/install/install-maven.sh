#!/usr/bin/env bash

set -e

# check installed version
if ! installed mvn; then
  installed_version=''
else
  installed_version="$(mvn --version | head -1 | sed -n "s/^.*Apache Maven \([0-9\.]*\).*$/\1/p")"
fi

# get latest version
mvn_url="https://www-us.apache.org/dist/maven"
latest_major_ver="$(wget -q -O- https://www-us.apache.org/dist/maven | grep 'href="maven-.*"' | sed -n 's/.*href="maven-\([[:digit:]]*\).*/\1/p' | sort -r | head -1)"
latest_version="$(curl -s "${mvn_url}/maven-${latest_major_ver}/" | grep '</a>' | tail -1 | sed -n "s/^.*<a.*>\(.*\)\/<\/a>.*$/\1/p")"
if [[ -z "${latest_version}" ]]; then
  echo "Unable to get latest version of maven" > /dev/stderr
  exit 1
fi

# install maven if not installed or version is outdated
if [[ -z "${installed_version}" ]] || verlt "${installed_version}" "${latest_version}"; then
  echo "Installing maven ${latest_version}"
  wget -q "${mvn_url}/maven-${latest_major_ver}/${latest_version}/binaries/apache-maven-${latest_version}-bin.tar.gz" -P /tmp

  sudo tar -xf "/tmp/apache-maven-${latest_version}-bin.tar.gz" -C /opt
  sudo rm -f "/tmp/apache-maven-${latest_version}-bin.tar.gz"
  sudo ln -s "/opt/apache-maven-${latest_version}" /opt/maven
  sudo rm -rf "/opt/apache-maven-${installed_version}"
fi

# add maven to PATH and configure environment variables
mkdir -p ${HOME}/.rc
cat > ${HOME}/.rc/maven << EOL
export M2_HOME=/opt/maven
export MAVEN_HOME=\${M2_HOME}
export PATH=\${M2_HOME}/bin:\${PATH}
EOL
if ! contains "source ${HOME}/.rc/maven" ${HOME}/.profile ; then
  echo -e "source ${HOME}/.rc/maven" >> ${HOME}/.profile
fi
