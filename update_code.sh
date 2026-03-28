#!/usr/bin/env bash
set -euo pipefail

# --- CONFIGURATION ---
DOCKER_PROJECT_DIR="/home/is214/is214-project/odoo" 
TEMP_DIR="/home/is214/deploy-temp"
LIVE_ADDONS_DIR="${DOCKER_PROJECT_DIR}/addons"

echo "[1] Moving to Docker project folder"
cd "${DOCKER_PROJECT_DIR}"

echo "[2] Stopping Odoo stack"
# Added '2>&1' here to prevent "Container Stopped" from looking like an error
sudo docker compose down 2>&1

echo "[3] Copying new code from Azure DevOps"
sudo mkdir -p "${LIVE_ADDONS_DIR}"
sudo cp -rT --no-preserve=ownership "${TEMP_DIR}/" "${LIVE_ADDONS_DIR}/"

echo "[4] Starting Odoo stack and rebuilding"
# '2>&1' here prevents "Container Started" from looking like an error
sudo docker compose up -d --build 2>&1

echo "Deployment finished successfully."
