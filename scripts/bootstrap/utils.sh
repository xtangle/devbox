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
    grep -Fqs -e "${1}"
  else
    grep -Fqs -e "${1}" "${2}"
  fi
}

function load {
  force=$( [[ "${1}" == "-f" ]] && shift && echo 1 || echo 0 )
  file="${1}"
  # shellcheck source=/dev/null
  function load_file { . "${file}" ;}
  if (( force )); then
    load_file
  else
    [[ -s "${file}" ]] && load_file
  fi
}

function verlt {
  dpkg --compare-versions "${1}" "lt" "${2}"
}

function source_in_profile {
  source_file="${1}"
  source_cmd="[[ -s \"${source_file}\" ]] && source \"${source_file}\""
  source_section_header="# sourced files"
  profile_file="${HOME}/.profile"
  if ! contains "${source_section_header}" "${profile_file}" ; then
    echo -e "\n${source_section_header}" >> "${profile_file}"
  fi
  if ! contains "${source_cmd}" "${profile_file}" ; then
    sed -i "/${source_section_header}/a ${source_cmd}" "${profile_file}"
  fi
}

function load_provision_vars {
  # shellcheck source=/dev/null
  source "${HOME}/devbox/tmp/provision-vars.sh"
}

export -f backup
export -f installed
export -f contains
export -f load
export -f verlt
export -f source_in_profile
export -f load_provision_vars
