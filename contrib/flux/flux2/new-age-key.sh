#!/bin/sh

set -eu

NAMESPACE="flux-system"
SECRET_NAME="sops-age"

if ! command -v age-keygen > /dev/null; then
    echo "'age' is not installed, please install first"
    exit 1
fi

if kubectl get secret -n "${NAMESPACE}" "${SECRET_NAME}" 2> /dev/null > /dev/null; then
    echo "This is cluster \"$(kubectl config current-context)\""
    echo "You've already have a sops age key defined. This option will overwrite it, meaning you'll have to re-encrypt all your secrets!"
    read -p "Do you want to proceed? (y/N): " choice

    if [[ "${choice}" != [Yy] ]]; then
        exit 0
    fi
fi

if ! kubectl get namespace "${NAMESPACE}"; then
    kubectl create ns "${NAMESPACE}"
fi
age-keygen | kubectl create secret generic "${SECRET_NAME}" -n="${NAMESPACE}" --from-file=age.agekey=/dev/stdin
