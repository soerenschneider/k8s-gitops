#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

OUTPUT=$(pass ${K8S_PASS_PATH})

AWS_ACCESS_KEY_ID="$(echo "$OUTPUT" | grep -e "^AWS_ACCESS_KEY_ID=" | cut -d'=' -f2)"
AWS_SECRET_ACCESS_KEY="$(echo "$OUTPUT" | grep -e "^AWS_SECRET_ACCESS_KEY=" | cut -d'=' -f2)"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
	--from-literal=AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin