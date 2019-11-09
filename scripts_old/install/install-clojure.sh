#!/usr/bin/env bash

set -e

# note: this script requires the following dependencies to be installed first:
# - install-java.sh

if installed lein; then
  echo ">> Updating lein"
  # upgrade lein script, hide curl output
  yes | lein upgrade 2> /dev/null
else
  echo ">> Installing lein"
  lein_file="${HOME}/bin/lein"
  curl -sSL https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -o "${lein_file}"
  chmod +x "${lein_file}"
  "${lein_file}" version
fi
