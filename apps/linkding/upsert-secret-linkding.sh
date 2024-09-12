#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

OUTPUT=$(pass ${K8S_PASS_PATH})

LD_SUPERUSER_NAME="$(echo "$OUTPUT" | grep -e "^SUPERUSER_NAME=" | cut -d'=' -f2)"
SECRET_KEY="$(echo "$OUTPUT" | grep -e "^SECRET_KEY=" | cut -d'=' -f2)"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=LD_SUPERUSER_NAME="${LD_SUPERUSER_NAME}" \
	--from-literal=SECRET_KEY="${SECRET_KEY}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin