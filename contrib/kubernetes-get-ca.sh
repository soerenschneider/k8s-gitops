#!/usr/bin/env bash

kubectl get cm -n kube-system kube-root-ca.crt -o json | jq -r '.data["ca.crt"]'
