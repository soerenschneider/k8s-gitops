#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

K8S_SECRET_NAME=route53-credentials
K8S_SECRET_FILE_NAME=sops-secret-route53-credentials.yaml
TF_VALUE=$(terraform -chdir=../../../contrib/terraform/route53-credentials output -json external-dns | jq -r '.["external-dns-'${K8S_CLUSTER_NAME}'"]')
AWS_SECRET_ACCESS_KEY=$(echo ${TF_VALUE} | jq -r '.access_key_secret')
AWS_ACCESS_KEY_ID=$(echo ${TF_VALUE} | jq -r '.access_key_id')

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=access-key-secret="${AWS_SECRET_ACCESS_KEY}" \
	--from-literal=access-key-id="${AWS_ACCESS_KEY_ID}" \
	--dry-run=client -o yaml | 
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin
