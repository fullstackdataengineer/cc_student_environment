#!/usr/bin/env bash
set -euo pipefail

# --- Azure Functions Core Tools v4 ---
sudo curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft.gpg >/dev/null
source /etc/os-release
echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/ubuntu/${VERSION_CODENAME}/prod ${VERSION_CODENAME} main" \
  | sudo tee /etc/apt/sources.list.d/microsoft-prod.list >/dev/null
sudo apt-get update
sudo apt-get install -y azure-functions-core-tools-4

# --- Python libs ---
python -m pip install --upgrade pip
python -m pip install \
  azure-identity \
  azure-storage-blob \
  azure-storage-queue \
  azure-data-tables \
  azure-keyvault-secrets \
  azure-eventhub \
  boto3

# --- Quick sanity checks (non-fatal) ---
echo "---- Versions ----"
docker --version || true
az version || true
aws --version || true
func --version || true
python --version || true
