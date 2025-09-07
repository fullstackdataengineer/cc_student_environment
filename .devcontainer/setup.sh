#!/usr/bin/env bash
set -Eeuo pipefail

CODENAME="$(. /etc/os-release; echo "$VERSION_CODENAME")"
ARCH="$(dpkg --print-architecture)"

echo "==> Purging stale Microsoft APT entries (…/ubuntu/<codename>/prod) BEFORE any apt update…"
# Remove any sources files that reference the bad path
sudo bash -lc '
  set -Eeuo pipefail
  mapfile -t BADFILES < <(grep -RIlE "packages\.microsoft\.com/ubuntu/.*/prod" \
    /etc/apt/sources.list /etc/apt/sources.list.d 2>/dev/null || true)
  if (( ${#BADFILES[@]} )); then
    printf "Removing: %s\n" "${BADFILES[@]}"
    sudo rm -f "${BADFILES[@]}"
  else
    echo "No stale files found."
  fi
  # Also comment any bad lines inside /etc/apt/sources.list (defensive)
  sudo sed -i -E "s|^([^#].*packages\.microsoft\.com/ubuntu/.*/prod.*)|# removed by setup.sh: \1|g" /etc/apt/sources.list || true
'

echo "==> Minimal prerequisites (after cleanup)…"
# These are usually present in devcontainers, but install if needed
sudo apt-get update
sudo apt-get install -y curl gnupg ca-certificates lsb-release software-properties-common apt-transport-https

echo "==> Add correct Microsoft repo (repos/microsoft-ubuntu-${CODENAME}-prod)…"
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
  | gpg --dearmor \
  | sudo tee /usr/share/keyrings/microsoft-archive-keyring.gpg >/dev/null

# Write a clearly-named list file so it doesn't clash with others
echo "deb [arch=${ARCH} signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/microsoft-ubuntu-${CODENAME}-prod ${CODENAME} main" \
  | sudo tee /etc/apt/sources.list.d/microsoft-ubuntu-${CODENAME}-prod.list >/dev/null

echo "==> Install Azure Functions Core Tools v4…"
sudo apt-get update
sudo apt-get install -y azure-functions-core-tools-4

echo "==> Install Terraform from HashiCorp repo…"
curl -fsSL https://apt.releases.hashicorp.com/gpg \
  | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=${ARCH} signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com ${CODENAME} main" \
  | sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null
sudo apt-get update
sudo apt-get install -y terraform

echo "==> Install Ansible (official PPA)…"
sudo add-apt-repository --yes ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible

echo "==> Upgrade pip and install Python SDKs…"
python -m pip install --upgrade pip
python -m pip install \
  azure-identity \
  azure-storage-blob \
  azure-storage-queue \
  azure-data-tables \
  azure-keyvault-secrets \
  azure-eventhub \
  boto3

echo "==> Version checks:"
docker --version || true
az version || true
aws --version || true
func --version || true
terraform -version || true
ansible --version || true
python --version || true

echo "✅ Setup completed."
