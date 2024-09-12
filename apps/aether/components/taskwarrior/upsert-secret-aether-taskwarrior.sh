#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

SECRET_VALUE="$(pass show configs/task-taskserver)"
taskd_credentials="taskd.credentials=${SECRET_VALUE}"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=taskd_credentials="${taskd_credentials}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin
