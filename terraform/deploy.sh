#!/usr/bin/env bash
set -euo pipefail
# --------------------------------------------------------------------
# deploy.sh
# Runs OpenTofu for the "infra" and "apps" stacks in sequence.
#
# • Assumes Minikube is running and ~/.kube/config points to it.
# • Assumes images backend:local and frontend:local already exist
#   inside Minikube’s Docker daemon (see build-in-minikube.sh).
#
# Optional environment variables:
#   BACKEND_IMAGE  – container tag for the backend  (default backend:local)
#   FRONTEND_IMAGE – container tag for the frontend (default frontend:local)
# --------------------------------------------------------------------

BACKEND_IMAGE=${BACKEND_IMAGE:-backend:local}
FRONTEND_IMAGE=${FRONTEND_IMAGE:-frontend:local}

# Helper for nicer logging
log() { printf "\n\033[1;34m>> %s\033[0m\n" "$*"; }

# --------------------------------------------------------------------
# 1. Deploy INFRASTRUCTURE (namespace infra)
# --------------------------------------------------------------------
log "Deploying infrastructure (Jenkins + Prometheus/Grafana)"
pushd infra >/dev/null

tofu init -input=false -upgrade
# Optional: run tests; ignore exit code if you prefer
tofu test || true
tofu apply -auto-approve

popd >/dev/null

# --------------------------------------------------------------------
# 2. Deploy APPLICATIONS (namespace apps)
# --------------------------------------------------------------------
log "Deploying applications (backend + frontend)"
pushd apps >/dev/null

tofu init -input=false -upgrade
tofu test || true
tofu apply \
  -var="backend_image=${BACKEND_IMAGE}" \
  -var="frontend_image=${FRONTEND_IMAGE}" \
  -auto-approve

popd >/dev/null

log "All stacks applied successfully!"
