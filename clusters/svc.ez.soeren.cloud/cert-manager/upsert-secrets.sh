#!/usr/bin/env bash

set -o pipefail
set -eu

CLUSTER_NAME="$(git rev-parse --show-prefix | awk -F'/' '{print $2}')"
SECRET_NAME="route53-credentials"
SECRET_FILE_NAME="sops-secret-route53-credentials.yaml"
echo "Upserting secret ${SECRET_NAME} for cluster ${CLUSTER_NAME}"

TF_VALUE=$(terraform -chdir=../../../contrib/terraform/route53-credentials output -json cert-manager | jq -r '.["cert-manager-'${CLUSTER_NAME}'"]')
AWS_SECRET_ACCESS_KEY=$(echo $TF_VALUE |jq -r '.access_key_secret')
AWS_ACCESS_KEY_ID=$(echo $TF_VALUE |jq -r '.access_key_id')

kubectl create secret generic "${SECRET_NAME}" \
	--from-literal=access-key-secret="${AWS_SECRET_ACCESS_KEY}" \
	--from-literal=access-key-id="${AWS_ACCESS_KEY_ID}" \
	--dry-run=client -o yaml | 
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${SECRET_FILE_NAME}" /dev/stdin 
