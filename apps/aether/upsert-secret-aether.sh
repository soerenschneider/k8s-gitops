#!/usr/bin/env bash

###########################################################
# Copy this header
###########################################################

set -o pipefail
set -eu

source "$(git rev-parse --show-toplevel)/contrib/variables.sh"
###########################################################

CALDAV_USER="soeren"
CALDAV_PASSWORD="$(pass infra/selfhosted/dav/radicale/soeren)"

CARDDAV_USER="${CALDAV_USER}"
CARDDAV_PASSWORD="${CALDAV_PASSWORD}"

WEATHER_APIKEY="$(pass keys/apikeys/openweathermap | grep ^apikey | cut -d' ' -f2)"

EMAIL_VALUES="$(pass email/send-only/aether)"
EMAIL_FROM=$(echo "${EMAIL_VALUES}" | grep ^EMAIL_FROM= | cut -d'=' -f2)
EMAIL_PASSWORD=$(echo "${EMAIL_VALUES}" | grep ^EMAIL_PASSWORD= | cut -d'=' -f2)
EMAIL_TO=$(echo "${EMAIL_VALUES}" | grep ^EMAIL_TO= | cut -d'=' -f2)
EMAIL_USERNAME=$(echo "${EMAIL_VALUES}" | grep ^EMAIL_USERNAME= | cut -d'=' -f2)

kubectl create secret generic "${K8S_SECRET_NAME}" \
	--from-literal=caldav_user="${CALDAV_USER}" \
	--from-literal=caldav_password="${CALDAV_PASSWORD}" \
	--from-literal=carddav_user="${CARDDAV_USER}" \
	--from-literal=carddav_password="${CARDDAV_PASSWORD}" \
	--from-literal=weather_apikey="${WEATHER_APIKEY}" \
	--from-literal=email_from="${EMAIL_FROM}" \
	--from-literal=email_password="${EMAIL_PASSWORD}" \
	--from-literal=email_to="${EMAIL_TO}" \
	--from-literal=email_username="${EMAIL_USERNAME}" \
	--dry-run=client -o yaml |
	sops -e --input-type=yaml --output-type=yaml -e \
	--encrypted-regex '^(data|stringData)$' \
	--output "${K8S_SECRET_FILE_NAME}" /dev/stdin
