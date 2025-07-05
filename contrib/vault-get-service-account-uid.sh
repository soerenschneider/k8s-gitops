#!/usr/bin/env bash

kubectl get serviceaccount -n vault-auth vault-kubernetes-auth -o jsonpath="{.metadata.uid}"
echo
