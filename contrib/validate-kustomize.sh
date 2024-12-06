#!/usr/bin/env bash

set -u
EXITCODE=0

kustomize_build_dir() {
  local dir="$1"

  if grep -qe '^helmCharts:$' "${dir}"/kustomization.y*ml; then
    echo "[SKIP]"
    return 0
  fi

  local OUTPUT
  # shellcheck disable=SC2034
  OUTPUT=$(kustomize build "${dir}")
  cmd_response=$?

  if [ $cmd_response -ne 0 ]; then
    if grep -qe '^kind: Component$' "${dir}"/kustomization.y*ml; then
      echo "SKIPPING"
      return 0
    fi

    echo "ERROR"
    EXITCODE=1
  else
    echo "OK"
  fi
}

kustomize_build_recursive() {
  # shellcheck disable=SC2044
  for dir in $(find "${1:-.}" -iname "kustomization.y*ml" -exec dirname {} \;); do
    echo "${dir}"
    kustomize_build_dir "${dir}"
  done
}

kustomize_build_recursive clusters
exit ${EXITCODE}
