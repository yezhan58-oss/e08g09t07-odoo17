#!/usr/bin/env bash
set -euo pipefail

# --- CONFIGURATION (Change these if your paths are different) ---
DOCKER_PROJECT_DIR="/home/is214/odoo" 
TEMP_DIR="/home/is214/deploy-temp"

# This folder must match the volume mapping in your docker-compose.yml
# Usually it is a folder named 'addons' in your project directory
LIVE_ADDONS_DIR="${DOCKER_PROJECT_DIR}/addons"

echo "[1] Moving to project directory"
cd "${DOCKER_PROJECT_DIR}"

echo "[2] Stopping Odoo services"
# This stops all containers in the stack (Odoo, DB, Nginx, etc.)
sudo docker-compose down

echo "[3] Syncing new code from Azure DevOps"
# Ensure the addons folder exists
sudo mkdir -p "${LIVE_ADDONS_DIR}"
# Copy the code we just pulled from GitHub into the Docker volume folder
sudo cp -rT --no-preserve=ownership "${TEMP_DIR}/" "${LIVE_ADDONS_DIR}/"

echo "[4] Restarting all services"
# --build ensures that if you added new python requirements, they get installed
sudo docker-compose up -d --build

echo "Deployment complete. Containers are spinning back up."
