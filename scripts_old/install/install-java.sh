#!/usr/bin/env bash

set -e

# install java jdk
if ! installed java; then
  # install Ubuntu's default jdk
  sudo -E add-apt-repository -y ppa:openjdk-r/ppa
  sudo -E apt-get -qy update
fi
sudo -E apt-get -qy install default-jdk

# configure environment variables
mkdir -p "${HOME}/.rc"
cat > "${HOME}/.rc/java" << EOL
export JAVA_HOME="/usr/lib/jvm/default-java"
EOL
source_in_profile "\${HOME}/.rc/java"
