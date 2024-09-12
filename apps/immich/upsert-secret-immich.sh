#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################
OUTPUT=$(pass ${PASS_PATH})

DB_USERNAME="$(echo "$OUTPUT" | grep -e "^DB_USERNAME=" | cut -d'=' -f2)"
DB_PASSWORD="$(echo "$OUTPUT" | grep -e "^DB_PASSWORD=" | cut -d'=' -f2)"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=DB_USERNAME="${DB_USERNAME}" \
	--from-literal=DB_PASSWORD="${DB_PASSWORD}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin
