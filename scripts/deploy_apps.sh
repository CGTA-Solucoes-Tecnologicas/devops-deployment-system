#!/usr/bin/env bash
set -euo pipefail
# Deploy frontend & backend using the same chart with different values

CHART="charts/app-chart"
NS="apps"

# Ensure namespace exists (Terraform already creates it, but this is harmless)
minikube kubectl -- get ns "$NS" >/dev/null 2>&1 || minikube kubectl -- create ns "$NS"

echo ">> Deploying FRONTEND (port 8080)"
helm upgrade --install frontend "$CHART" \
  -n apps \
  --reset-values \
  -f "$CHART"/values-frontend.yaml \
  --wait --timeout 10m --debug



echo ">> Deploying BACKEND (port 3001)"
helm upgrade --install backend "$CHART" \
  -n apps \
  --reset-values \
  -f "$CHART"/values-backend.yaml \
  --wait --timeout 10m --debug


echo ">> Done. Services:"
minikube kubectl -- -n "$NS" get svc
