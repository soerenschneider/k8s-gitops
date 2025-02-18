#!/usr/bin/env bash

kubectl -n vault-auth get secret vault-kubernetes-auth-secret -o jsonpath="{.data.token}" | base64 --decode; echo
