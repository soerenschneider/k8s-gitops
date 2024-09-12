#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

sops -d mysqld-exporter-config-sops.cnf | \
    kubectl create secret generic "${K8S_SECRET_NAME}" \
        --from-file=my.cnf=/dev/stdin \
        --dry-run=client -o yaml |
    sops -e --input-type=yaml --output-type=yaml -e \
    	--encrypted-regex '^(data|stringData)$' \
    	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin
