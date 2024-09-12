#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

OUTPUT=$(pass ${K8S_PASS_PATH})

BACKUP_ID="${K8S_APP_SUB}"
S3_DIR="restic-${BACKUP_ID}"
AWS_ACCESS_KEY_ID="$(echo "$OUTPUT" | grep -e "^AWS_ACCESS_KEY_ID=" | cut -d'=' -f2)"
AWS_SECRET_ACCESS_KEY="$(echo "$OUTPUT" | grep -e "^AWS_SECRET_ACCESS_KEY=" | cut -d'=' -f2)"
RESTIC_PASSWORD="$(echo "$OUTPUT" | grep -e "^RESTIC_PASSWORD=" | cut -d'=' -f2)"
MARIADB_USER="$(echo "$OUTPUT" | grep -e "^MARIADB_USER=" | cut -d'=' -f2)"
MARIADB_PASSWORD="$(echo "$OUTPUT" | grep -e "^MARIADB_PASSWORD=" | cut -d'=' -f2)"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
	--from-literal=AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
	--from-literal=RESTIC_PASSWORD="${RESTIC_PASSWORD}" \
  --from-literal=RESTIC_BACKUP_ID="${BACKUP_ID}" \
  --from-literal=MARIADB_USER="${MARIADB_USER}" \
  --from-literal=MARIADB_PASSWORD="${MARIADB_PASSWORD}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin
