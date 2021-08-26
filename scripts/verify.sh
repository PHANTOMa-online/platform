#!/usr/bin/env bash

# This script verifies the reconciliation of all of the platform
# services in the cluster.

# This script is a meant to be called by other scripts that set
# up the surrounding environment in the cluster beforehand.

echo "INFO - Waiting for kustomization/system reconciliation"
kubectl -n flux-system wait kustomization/system \
  --for=condition=ready \
  --timeout=5m

echo "INFO - Waiting for kustomization/system reconciliation"
kubectl -n cert-manager wait helmrelease/cert-manager \
  --for=condition=ready \
  --timeout=5m
