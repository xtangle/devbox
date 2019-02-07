#!/usr/bin/env bash

# shellcheck disable=2155

function reset_results_file {
  if [[ -f "${RESULTS_FILE}" ]]; then
    rm "${RESULTS_FILE}"
  fi
  echo 'Script name,SHA1 checksum,Timestamp,Status code' > "${RESULTS_FILE}"
}

function remove_record {
  local script="$1"
  sed -i "/^${script}/d" "${RESULTS_FILE}"
}

function print_results {
  local failed_installs=$(grep -P ",(?!0)\d*$" "${RESULTS_FILE}" | cut -d',' -f1)
  local -i status
  if [[ -z "${failed_installs}" ]]; then
    echo ">> All scripts ran successfully"
    status=0
  else
    echo ">> Some scripts terminated with a failed status:" > /dev/stderr
    echo "${failed_installs}" > /dev/stderr
    status=1
  fi
  echo ">> Results are written to ${RESULTS_FILE}"
  return ${status}
}

function run {
  local script="$1"
  local script_path=$(which "${script}")
  local version="$(sha1sum "${script_path}" | cut -d' ' -f1)"
  local args=( "${@:2}" )

  echo ">> Running script ${script}"
  "${script}" "${args[@]}"
  local status=$?
  local timestamp=$(TZ=${TIMEZONE:-$(cat /etc/timezone)} date +'%Y-%m-%d %H:%M:%S %Z%z')
  remove_record "${script}"
  echo "${script},${version},${timestamp},${status}" >> "${RESULTS_FILE}"
  echo ">> Script ${script} terminated with status code ${status}" > "$( (( status == 0 )) && echo /dev/stdout || echo /dev/stderr )"
}
