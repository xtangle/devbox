#!/usr/bin/env bash

function backup {
  for file in "$@"; do
    if [[ -f "${file}" && ! -f "${file}.bkup" ]]; then
      sudo cp -af "${file}" "${file}.bkup"
    fi
  done
}

function installed {
  hash "${1}" 2> /dev/null
}

function contains {
  if [[ -z "${2}" ]]; then
    grep -qs "${1}"
  else
    grep -qs "${1}" ${2}
  fi
}

function verlt {
  dpkg --compare-versions "${1}" "lt" "${2}"
}

export -f backup
export -f installed
export -f contains
export -f verlt
