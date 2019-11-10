#!/usr/bin/env bash

# shellcheck disable=2155

# unused
function clear_logs_dir {
  if [[ -d "${LOGS_DIR}" ]]; then
    rm -rf "${LOGS_DIR}"
  fi
}

# unused
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

function prepare_results_file {
  if [[ ! -f "${RESULTS_FILE}" ]]; then
    echo 'Script path,SHA1 checksum,Timestamp,Status code' > "${RESULTS_FILE}"
  fi
}

function run {
  local step="${1}"
  local script_path="${2}"
  local script_name="$(basename "${script_path}" | cut -f 1 -d '.')"
  local script_tag="[${step}] [${script_name}]"
  local log_path="${LOGS_DIR}/${step}/${script_name%.*}.log"
  local version="$(sha1sum "${script_path}" | cut -d' ' -f1)"
  local args=( "${@:3}" )

  prepare_results_file
  mkdir -p "$(dirname "${log_path}")"
  echo ">> ${script_tag} Executing script..."
  "${script_path}" "${args[@]}" > "${log_path}" 2>&1
  local status=${?}
  local timestamp=$(TZ=${PROVISION_TIMEZONE:-$(cat /etc/timezone)} date +'%Y-%m-%d %H:%M:%S %Z%z')
  echo "${script_path},${version},${timestamp},${status}" >> "${RESULTS_FILE}"
  echo ">> ${script_tag} Script exited with status code ${status}" > "$( (( status == 0 )) && echo /dev/stdout || echo /dev/stderr )"
}
