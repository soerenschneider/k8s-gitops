#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

OUTPUT=$(pass ${K8S_PASS_PATH})

MYSQL_USER="$(echo "$OUTPUT" | grep -e "^MYSQL_USER=" | cut -d'=' -f2)"
MYSQL_PASSWORD="$(echo "$OUTPUT" | grep -e "^MYSQL_PASSWORD=" | cut -d'=' -f2)"
NEXTCLOUD_ADMIN_USER="$(echo "$OUTPUT" | grep -e "^NEXTCLOUD_ADMIN_USER=" | cut -d'=' -f2)"
NEXTCLOUD_ADMIN_PASSWORD="$(echo "$OUTPUT" | grep -e "^NEXTCLOUD_ADMIN_PASSWORD=" | cut -d'=' -f2)"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=MYSQL_USER="${MYSQL_USER}" \
	--from-literal=MYSQL_PASSWORD="${MYSQL_PASSWORD}" \
	--from-literal=NEXTCLOUD_ADMIN_USER="${NEXTCLOUD_ADMIN_USER}" \
	--from-literal=NEXTCLOUD_ADMIN_PASSWORD="${NEXTCLOUD_ADMIN_PASSWORD}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin
