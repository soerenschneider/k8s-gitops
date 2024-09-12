#!/usr/bin/env bash

set -o pipefail
set -eu

PASS_PREFIX="k8s/common"
SECRET_NAME_GITLAB="renovatebot-gitlab"
SECRET_NAME_GITHUB="renovatebot-github"
SECRET_NAME_GHCR="cr-ghcr"
SECRET_FILE_NAME="sops-secret-tokens.yaml"

echo "Upserting secret ${SECRET_NAME_GITLAB}, ${SECRET_NAME_GITHUB}, ${SECRET_NAME_GHCR}"
SECRET_VALUE_GHCR=$(pass ${PASS_PREFIX}/${SECRET_NAME_GHCR})
SECRET_VALUE_GITLAB=$(pass ${PASS_PREFIX}/${SECRET_NAME_GITLAB})
SECRET_VALUE_GITHUB=$(pass ${PASS_PREFIX}/${SECRET_NAME_GITHUB})

RENOVATE_HOST_RULES='[{"hostType": "docker","matchHost": "ghcr.io","username": "soerenschneider","password": "'"${SECRET_VALUE_GHCR}"'"}]'

kubectl create secret generic tokens \
	--from-literal=gitlab-token="${SECRET_VALUE_GITLAB}" \
	--from-literal=github-token="${SECRET_VALUE_GITHUB}" \
	--from-literal=RENOVATE_HOST_RULES="${RENOVATE_HOST_RULES}" \
	--dry-run=client -o yaml | 
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${SECRET_FILE_NAME}" /dev/stdin 

