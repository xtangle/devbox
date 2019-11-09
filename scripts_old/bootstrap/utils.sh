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
  force=$( [[ "${1}" == "-f" ]] && echo 1 || echo 0 ); (( force )) && shift
  file="${1}"
  if (( force )) || [[ -s "${file}" ]]; then
    # shellcheck source=/dev/null
    . "${file}"
  fi
}

function verlt {
  dpkg --compare-versions "${1}" "lt" "${2}"
}

function release_lock_file {
  force=$( [[ "${1}" == "-f" ]] && echo 1 || echo 0 ); (( force )) && shift
  lock_file="${1}"
  echo ">> looking for processes using the lock file: ${lock_file}"
  if [[ ! -f "${lock_file}" ]]; then
    echo ">> lock file not found, proceeding"
    return
  fi
  mapfile -t pids < <(sudo lsof "${lock_file}" | tail +2 | tr -s ' ' | cut -d' ' -f2)
  if [[ ${#pids[@]} -eq 0 ]]; then
    echo ">> no processes found"
    return
  fi
  for pid in "${pids[@]}"; do
    echo ">> killing process: $(ps -p "${pid}" -o comm=) (pid: ${pid})"
    i=0
    while sudo kill "${pid}" 2>/dev/null; do 
      sleep 1
      let i=i+1
      if (( i >= 30 )); then
        if (( force )); then
          echo ">> warning: process could not be killed in ${i} seconds, killing process forcefully"
          sudo kill -9 "${pid}"
        else
          echo ">> warning: process could not be killed in ${i} seconds"
        fi
        break
      fi
    done
  done
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
  source "${HOME}/.load-provision-vars.sh"
}

export -f backup
export -f installed
export -f contains
export -f load
export -f verlt
export -f release_lock_file
export -f source_in_profile
export -f load_provision_vars
