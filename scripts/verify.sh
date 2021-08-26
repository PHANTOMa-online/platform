#!/usr/bin/env bash

# This script verifies the reconciliation of all of the platform
# services in the cluster.

# This script is meant to be run locally to test the entire platform.
# A similar check is also done in CI.

echo "INFO - Waiting for kustomization/system reconciliation"
kubectl -n flux-system wait kustomization/system \
  --for=condition=ready \
  --timeout=5m

echo "INFO - Waiting for kustomization/system reconciliation"
kubectl -n cert-manager wait helmrelease/cert-manager \
  --for=condition=ready \
  --timeout=5m
