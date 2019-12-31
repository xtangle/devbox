#!/usr/bin/env bash

# shellcheck disable=2155

# unused
function clear_logs_dir {
  if [[ -d "${DEVBOX_LOGS_DIR}" ]]; then
    rm -rf "${DEVBOX_LOGS_DIR}"
  fi
}

# unused
function print_results {
  local failed_installs=$(grep -P ",(?!0)\d*$" "${DEVBOX_RESULTS_FILE}" | cut -d',' -f1)
  local -i status
  if [[ -z "${failed_installs}" ]]; then
    echo ">> All scripts ran successfully"
    status=0
  else
    echo ">> Some scripts terminated with a failed status:" > /dev/stderr
    echo "${failed_installs}" > /dev/stderr
    status=1
  fi
  echo ">> Logs can be found at ${DEVBOX_LOGS_DIR}"
  echo ">> Summary of results can be found at ${DEVBOX_RESULTS_FILE}"
  return ${status}
}

function prepare_results_file {
  if [[ ! -f "${DEVBOX_RESULTS_FILE}" ]]; then
    echo 'Context,Step,Script path,SHA1 checksum,Timestamp,Status code' > "${DEVBOX_RESULTS_FILE}"
  fi
}

function run {
  local context="${1}"
  local step="${2}"
  local script_path="${3}"
  local script_name="$(basename "${script_path}" | cut -f 1 -d '.')"
  local script_tag="[${context}] [${step}] [${script_name}]"
  local log_path="${DEVBOX_LOGS_DIR}/${context}/${step}/${script_name%.*}.log"
  local script_hash="$(sha1sum "${script_path}" | cut -d' ' -f1)"
  local args=( "${@:4}" )

  prepare_results_file
  mkdir -p "$(dirname "${log_path}")"
  echo ">> ${script_tag} Executing script..."
  "${script_path}" "${args[@]}" > "${log_path}" 2>&1
  local status=${?}
  local timestamp=$(TZ=${PROVISION_TIMEZONE:-$(cat /etc/timezone)} date +'%Y-%m-%d %H:%M:%S %Z%z')
  echo "${context},${step},${script_path},${script_hash},${timestamp},${status}" >> "${DEVBOX_RESULTS_FILE}"
  echo ">> ${script_tag} Script exited with status code ${status}" > "$( (( status == 0 )) && echo /dev/stdout || echo /dev/stderr )"
}
