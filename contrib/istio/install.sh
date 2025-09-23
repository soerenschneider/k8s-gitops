#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

cluster=$1
operator="${SCRIPT_DIR}/istio-operator-${cluster}.yaml"
if ! [[ -f $operator ]]; then
    operator="${SCRIPT_DIR}/${cluster}"
    if ! [[ -f $operator ]]; then
      echo "no such file: $operator"
      exit 1
    fi
fi

istioctl install -f "${operator}"
