#!/usr/bin/env bash
set -euo pipefail

# --- CONFIGURATION (Based on your 'find' result) ---
DOCKER_PROJECT_DIR="/home/is214/is214-project/odoo" 
TEMP_DIR="/home/is214/deploy-temp"

# Based on your docker-compose.yml, the code must go here:
LIVE_ADDONS_DIR="${DOCKER_PROJECT_DIR}/addons"

echo "[1] Navigating to Docker project"
cd "${DOCKER_PROJECT_DIR}"

echo "[2] Shutting down Odoo Stack"
# This stops Odoo, Nginx, Postgres, and the monitoring tools
sudo docker-compose down

echo "[3] Syncing new code from Azure DevOps"
# Ensure the addons directory exists on the host
sudo mkdir -p "${LIVE_ADDONS_DIR}"

# Copy the fresh code from the 'deploy-temp' (where Git cloned it)
# to the 'addons' folder Docker is watching.
sudo cp -rT --no-preserve=ownership "${TEMP_DIR}/" "${LIVE_ADDONS_DIR}/"

echo "[4] Restarting Stack with Build"
# --build is important because your Odoo nodes use 'build: context: .'
# This will trigger a re-build of the Odoo image if your Dockerfile changed.
sudo docker-compose up -d --build

echo "Deployment complete. Checking status..."
sudo docker-compose ps
