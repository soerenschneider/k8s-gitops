#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

OUTPUT=$(pass ${K8S_PASS_PATH})

GF_DATABASE_USER="$(echo "$OUTPUT" | grep -e "^GF_DATABASE_USER=" | cut -d'=' -f2)"
GF_DATABASE_PASSWORD="$(echo "$OUTPUT" | grep -e "^GF_DATABASE_PASSWORD=" | cut -d'=' -f2)"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=GF_DATABASE_USER="${GF_DATABASE_USER}" \
	--from-literal=GF_DATABASE_PASSWORD="${GF_DATABASE_PASSWORD}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin
