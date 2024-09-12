#!/usr/bin/env bash

set -o pipefail
set -eu

SECRET_NAME="microbin"
SECRET_FILE_NAME="sops-secret-credentials.yaml"
NAMESPACE=microbin
echo "Upserting secret ${SECRET_NAME}"


PASS_PREFIX="k8s/prd/microbin"

MICROBIN_ADMIN=soeren
MICROBIN_ADMIN_PASS=secret

kubectl create secret generic "${SECRET_NAME}" \
	--namespace="${NAMESPACE}" \
	--from-literal=MICROBIN_ADMIN_USERNAME="${MICROBIN_ADMIN}" \
	--from-literal=MICROBIN_ADMIN_PASSWORD="${MICROBIN_ADMIN_PASS}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${SECRET_FILE_NAME}" /dev/stdin 
