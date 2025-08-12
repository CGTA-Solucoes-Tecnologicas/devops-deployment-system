#!/usr/bin/env bash
set -euo pipefail
# Deploy frontend & backend using the same chart with different values

CHART="charts/app-chart"
NS="apps"

# Ensure namespace exists (Terraform already creates it, but this is harmless)
minikube kubectl -- get ns "$NS" >/dev/null 2>&1 || minikube kubectl -- create ns "$NS"

echo ">> Deploying FRONTEND (port 8080)"
helm upgrade --install frontend "$CHART" \
  --namespace "$NS" \
  --set image.repository=frontend:local \
  --set image.tag="frontend" \
  --set image.pullPolicy=IfNotPresent \
  --set service.type=NodePort \
  --set service.port=8080 \
  --set-string podAnnotations."prometheus\.io/scrape"="true" \
  --set-string podAnnotations."prometheus\.io/port"="8080" \
  --wait --timeout 10m

echo ">> Deploying BACKEND (port 3000)"
helm upgrade --install backend "$CHART" \
  --namespace "$NS" \
  --set image.repository=backend:local \
  --set image.tag="backend" \
  --set image.pullPolicy=IfNotPresent \
  --set service.type=NodePort \
  --set service.port=3000 \ 
  --set-string podAnnotations."prometheus\.io/scrape"="true" \
  --set-string podAnnotations."prometheus\.io/port"="3000" \
  --wait --timeout 10m

echo ">> Done. Services:"
minikube kubectl -- -n "$NS" get svc
