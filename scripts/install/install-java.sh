#!/usr/bin/env bash

set -e

# install java jdk
if ! installed java; then
  # install Ubuntu's default jdk
  sudo add-apt-repository ppa:openjdk-r/ppa
  sudo -E apt-get -qq update
  sudo -E apt-get -qq install default-jdk

  mkdir -p ${HOME}/.rc
  echo "export JAVA_HOME=\"/usr/lib/jvm/default-java\"" > ${HOME}/.rc/java
  if ! contains "source ${HOME}/.rc/java" ${HOME}/.profile ; then
    echo -e "source ${HOME}/.rc/java" >> ${HOME}/.profile
  fi
fi
