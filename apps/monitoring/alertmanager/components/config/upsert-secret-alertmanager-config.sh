#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

sops -d alertmanager-config-sops.yaml | \
    kubectl create secret generic "${K8S_SECRET_NAME}" \
        --from-file=alertmanager.yaml=/dev/stdin \
        --dry-run=client -o yaml |
    sops -e --input-type=yaml --output-type=yaml -e \
    	--encrypted-regex '^(data|stringData)$' \
    	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin
