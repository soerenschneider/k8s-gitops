#!/usr/bin/env bash

set -o pipefail
set -eu

CLUSTER_NAME="$(git rev-parse --show-prefix | awk -F'/' '{print $2}')"
NAMESPACE="$(basename $(pwd))"

##############################################################################
##############################################################################

K8S_SECRET_NAME="smbcreds"
K8S_SECRET_FILE_NAME="sops-secret-${K8S_SECRET_NAME}.yaml"

K8S_PASS_PATH="infra/selfhosted/k8s/${CLUSTER_NAME}/media-${K8S_SECRET_NAME}"
OUTPUT=$(pass ${K8S_PASS_PATH})

SMB_USERNAME="$(echo "$OUTPUT" | grep -e "^SMB_USERNAME=" | cut -d'=' -f2)"
SMB_PASSWORD="$(echo "$OUTPUT" | grep -e "^SMB_PASSWORD=" | cut -d'=' -f2)"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=username="${SMB_USERNAME}" \
	--from-literal=password="${SMB_PASSWORD}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin