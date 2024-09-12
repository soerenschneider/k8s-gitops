#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

BACKUP_ID=radicale
S3_DIR="restic-${BACKUP_ID}"
TF_VALUE=$(terraform -chdir=../../../../tf-aws-s3-backups output -json ids | jq -r '.["'"${S3_DIR}"'"]')
AWS_ACCESS_KEY_ID=$(echo "$TF_VALUE" | jq -r '.id')
AWS_SECRET_ACCESS_KEY=$(echo "$TF_VALUE" | jq -r '.secret')
RESTIC_REPOSITORY="s3:s3.amazonaws.com/soerenschneider-backups/${S3_DIR}"
RESTIC_PASSWORD="$(pass backups/restic/prod/${BACKUP_ID})"

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
	--from-literal=AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
	--from-literal=RESTIC_REPOSITORY="${RESTIC_REPOSITORY}" \
	--from-literal=RESTIC_PASSWORD="${RESTIC_PASSWORD}" \
  --from-literal=RESTIC_BACKUP_ID="${BACKUP_ID}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin