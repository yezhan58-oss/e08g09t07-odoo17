#!/usr/bin/env bash
set -euo pipefail

DOCKER_PROJECT_DIR="/home/is214/is214-project/odoo" 
TEMP_DIR="/home/is214/deploy-temp"
LIVE_ADDONS_DIR="${DOCKER_PROJECT_DIR}/addons"

echo "[1] Moving to Docker project folder"
cd "${DOCKER_PROJECT_DIR}"

echo "[2] Stopping Odoo stack"
# We use 'docker compose' (no hyphen)
sudo docker compose down

echo "[3] Copying new code from Azure DevOps"
sudo mkdir -p "${LIVE_ADDONS_DIR}"
sudo cp -rT --no-preserve=ownership "${TEMP_DIR}/" "${LIVE_ADDONS_DIR}/"

echo "[4] Starting Odoo stack and rebuilding"
# Redirecting stderr to stdout to prevent Azure from showing fake errors
sudo docker compose up -d --build 2>&1

echo "Deployment finished successfully."
