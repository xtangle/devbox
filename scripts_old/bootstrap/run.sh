#!/usr/bin/env bash

# shellcheck disable=2155

function reset_results_file {
  if [[ -f "${RESULTS_FILE}" ]]; then
    rm -f "${RESULTS_FILE}"
  fi
  echo 'Script name,SHA1 checksum,Timestamp,Status code' > "${RESULTS_FILE}"
}

function clear_logs_dir {
  if [[ -d "${LOGS_DIR}" ]]; then
    rm -rf "${LOGS_DIR}"
  fi
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
  echo ">> Logs can be found at ${LOGS_DIR}"
  echo ">> Summary of results can be found at ${RESULTS_FILE}"
  return ${status}
}

function run {
  local script="${1}"
  local script_path="$(command -v "${script}")"
  local log_file="${script%.*}.log"
  local version="$(sha1sum "${script_path}" | cut -d' ' -f1)"
  local args=( "${@:2}" )

  load_provision_vars
  mkdir -p "${LOGS_DIR}"
  echo ">> [${script}] Executing script..."
  "${script}" "${args[@]}" > "${LOGS_DIR}/${log_file}" 2>&1
  local status=${?}
  local timestamp=$(TZ=${PROVISION_TIMEZONE:-$(cat /etc/timezone)} date +'%Y-%m-%d %H:%M:%S %Z%z')
  sed -i "/^${script}/d" "${RESULTS_FILE}"
  echo "${script},${version},${timestamp},${status}" >> "${RESULTS_FILE}"
  echo ">> [${script}] Script exited with status code ${status}" > "$( (( status == 0 )) && echo /dev/stdout || echo /dev/stderr )"
}
