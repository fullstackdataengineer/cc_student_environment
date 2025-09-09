# Cloud Computing Starter (GitHub Codespaces)

Welcome! This repo gives you a ready-to-use cloud dev environment in your browser using **GitHub Codespaces**. You’ll get:

- Ubuntu (containerized)
- Docker Engine (build and run containers inside Codespaces)
- Python 3.11
- Azure CLI (`az`)
- Azure Functions Core Tools (v4)
- AWS CLI + `boto3`
- Common Azure Python SDKs
- Helpful VS Code extensions preinstalled
- Ansible
- Terraform

> 💡 **What is Codespaces?**  
> GitHub Codespaces is a cloud development environment that launches a full Linux container with your tools and extensions already installed. You code in the browser (or VS Code desktop), without setting up your laptop. Great for first-time cloud developers!

---

## 🚀 Launch in Codespaces

**Click the button below** to create your Codespace for this repository:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/fullstackdataengineer/cc_student_environment?quickstart=1)

---

## 🧰 What’s included

- **Docker Engine (Docker-in-Docker)** – so `docker build` and `docker run` work _inside_ the dev container  
- **Python 3.11** – via Dev Container Feature  
- **Azure** – `az` CLI + **Azure Functions Core Tools v4** for local development  
- **AWS** – AWS CLI + `boto3`  
- **Python SDKs preinstalled** – `azure-identity`, `azure-storage-blob`, `azure-storage-queue`, `azure-data-tables`, `azure-keyvault-secrets`, `azure-eventhub`, `boto3`
- **Ansible**
- **Terraform**
- **VS Code Extensions** – Python, Pylance, Azure Functions, Docker, Azure Account, Azure CLI, AWS Toolkit

When the Codespace starts, it reads the files in `.devcontainer/` to build your environment and then runs a setup script automatically.

---

## 📁 Repo structure

```
.devcontainer/
devcontainer.json # Defines the environment (features, extensions, post-create steps)
setup.sh # Installs Functions Core Tools + Python SDKs  
```  
---

## 🧪 First-run checks

Open a terminal and confirm versions:

```bash
docker --version
az version
aws --version
func --version
python --version
```  
🔐 Sign in to cloud CLIs  

```  
# Azure
az login

# AWS (basic credentials)
aws configure
```  
