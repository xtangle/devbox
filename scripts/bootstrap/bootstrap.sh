#!/usr/bin/env bash

function bootstrap {
  export vagrant_files="${HOME}/vagrant-files"
  export vagrant_scripts="${HOME}/vagrant-scripts"

  export PATH="${vagrant_scripts}/configure:${vagrant_scripts}/install:${PATH}"

  export RESULTS_FILE="${HOME}/.provision-results.csv"

  # sources all files in the bootstrap directory except this one
  eval $(find "${vagrant_scripts}/bootstrap" -maxdepth 1 -type f ! -name 'bootstrap.sh' -exec echo source \'{}\'';' \;)
}

export -f bootstrap
