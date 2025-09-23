#!/usr/bin/env bash

echo "Service Account UID vault-auth"
kubectl get serviceaccount -n vault-auth vault-kubernetes-auth -o jsonpath="{.metadata.uid}"
echo

echo "Service Account UID external-secrets"
kubectl get serviceaccount -n external-secrets-system external-secrets -o jsonpath="{.metadata.uid}"
echo
