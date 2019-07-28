#!/usr/bin/env bash

function bootstrap {
  export VAGRANT_FILES="${HOME}/vagrant-files"
  export VAGRANT_SCRIPTS="${HOME}/vagrant-scripts"

  export PATH="${VAGRANT_SCRIPTS}/configure:${VAGRANT_SCRIPTS}/install:${PATH}"

  export RESULTS_FILE="${HOME}/.provision-results.csv"

  export HAS_BOOTSTRAPED="true"

  # sources all files in the bootstrap directory except this one
  eval "$(find "${VAGRANT_SCRIPTS}/bootstrap" -maxdepth 1 -type f ! -name 'bootstrap.sh' -exec echo source \'{}\'';' \;)"
}

export -f bootstrap
