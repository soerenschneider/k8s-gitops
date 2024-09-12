#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

SECRET_DATA=$(pass ${K8S_PASS_PATH})

GITHUB_REGISTRY_USERNAME="$(echo "${SECRET_DATA}" | grep -e "^GITHUB_REGISTRY_USERNAME=" | cut -d'=' -f2)"
GITHUB_REGISTRY_TOKEN="$(echo "${SECRET_DATA}" | grep -e "^GITHUB_REGISTRY_TOKEN=" | cut -d'=' -f2)"
GITLAB_TOKEN="$(echo "${SECRET_DATA}" | grep -e "^GITLAB_TOKEN=" | cut -d'=' -f2)"
GITHUB_TOKEN="$(echo "${SECRET_DATA}" | grep -e "^GITHUB_TOKEN=" | cut -d'=' -f2)"

RENOVATE_HOST_RULES='[{"hostType": "docker","matchHost": "ghcr.io","username": "'"${GITHUB_REGISTRY_USERNAME}"'", "password": "'"${GITHUB_REGISTRY_TOKEN}"'"}]'

kubectl create secret generic ${K8S_SECRET_NAME} \
	--from-literal=gitlab-token="${GITLAB_TOKEN}" \
	--from-literal=github-token="${GITHUB_TOKEN}" \
	--from-literal=RENOVATE_HOST_RULES="${RENOVATE_HOST_RULES}" \
	--dry-run=client -o yaml | 
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin

