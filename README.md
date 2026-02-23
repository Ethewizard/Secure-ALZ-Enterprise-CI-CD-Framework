---

# 🌐 Azure Landing Zone: Enterprise CI/CD Framework

An enterprise-scale, secure, and fully automated Azure Landing Zone (ALZ) deployment. This project leverages **2026 Industry Standards** to provide a governed foundation for critical infrastructure workloads, inspired by the operational needs of the **critical infrastructure entities**.

---

## 🚀 Key Features

* **Zero-Trust Authentication:** Uses **OpenID Connect (OIDC)** with GitHub Actions to eliminate long-lived secrets and passwords.
* **Azure Verified Modules (AVM):** Built using the 2026 modular standard for high reliability and consistent performance.
* **Policy-Driven Governance:** Automated guardrails ensure compliance (e.g., NERC CIP alignment) from the moment a resource is created.
* **Automated CI/CD:** Integrated **GitHub Actions** pipelines for automated Planning, Application, Nightly Drift Detection, and Application Deployment.
* **State Management:** Secure remote state tracking with **Azure Storage** and blob-locking.
* **Workload Spokes:** Application workloads deploy as isolated spoke VNets peered to the hub with centralized logging.

---

## 🏗️ Architecture Overview

The landing zone follows a **Platform vs. Workload** separation, even within a single-subscription development environment:

1. **Identity & Governance:** A Management Group hierarchy that organizes resources and enforces global security policies.
2. **Connectivity (Hub & Spoke):** A central "Hub" Virtual Network (10.100.0.0/16) containing shared services like Azure Firewall and VPN Gateways.
3. **Management:** A centralized Log Analytics Workspace for unified auditing, monitoring, and SIEM (Sentinel) integration.
4. **Workloads:** Application spokes (e.g., Milk & Ink Studio at 10.101.0.0/16) peered to the hub with isolated networking.

---

## 📂 Project Structure

```text
Secure-ALZ-Enterprise-CI-CD-Framework/
├── .github/workflows/
│   ├── terraform-plan.yml        # Plan on PR
│   ├── terraform-apply.yml       # Apply on merge to main
│   ├── drift-detection.yml       # Nightly ClickOps detection
│   ├── deploy-frontend.yml       # Milk & Ink React → Azure Static Web Apps
│   └── deploy-backend.yml        # Milk & Ink FastAPI → Azure Container Apps
├── modules/
│   ├── networking/               # Reusable VNet + subnet blueprint
│   └── governance/               # Policy assignment blueprint
├── platform/
│   ├── identity/                 # Management Group hierarchy (AVM)
│   ├── management/               # Log Analytics workspace
│   ├── connectivity/             # Hub VNet (10.100.0.0/16)
│   └── workloads/
│       └── milkink/              # Milk & Ink spoke (10.101.0.0/16)
├── scripts/
│   └── pre-deploy-check.sh       # Pre-deployment validation
├── app/
│   ├── frontend/                 # Milk & Ink React app (Vite)
│   └── backend/                  # Milk & Ink FastAPI app (Docker)
├── providers.tf                  # AzureRM + ALZ + AzAPI providers (OIDC)
├── backend.tf                    # Remote state in Azure Storage (OIDC)
├── variables.tf                  # Input variables
├── locals.tf                     # Computed naming conventions
├── main.tf                       # Orchestrator (calls all 4 layers)
└── outputs.tf                    # Surfaces URLs and resource IDs
```

---

## 🛠️ Getting Started

### Prerequisites

* **Terraform CLI** (v1.12+)
* **Azure CLI** (Authenticated via `az login`)
* **GitHub CLI** (For managing repository secrets)

### Local Deployment

1. Clone this repository:
```bash
git clone https://github.com/Ethewizard/Secure-ALZ-Enterprise-CI-CD-Framework.git
```

2. Create your `terraform.tfvars` (gitignored):
```hcl
subscription_id    = "your-azure-subscription-id"
tenant_id          = "your-azure-tenant-id"
parent_resource_id = "/providers/Microsoft.Management/managementGroups/your-tenant-root"
```

3. Initialize and deploy:
```bash
terraform init
terraform plan
terraform apply
```

---

## 🔐 Security & Compliance

* **Federated Identity:** GitHub Actions uses temporary OIDC tokens — no stored passwords.
* **Resource Guarding:** `pre-deploy-check.sh` validates formatting before every deployment.
* **Drift Detection:** Nightly scans flag unauthorized portal changes as GitHub Issues.
* **Network Isolation:** Workload spokes are VNet-peered to the hub but isolated from each other.
* **Secrets Management:** Application secrets stored in Azure Key Vault with RBAC and network deny-by-default.

---

## 🎬 Milk & Ink Studio Workload

The first application workload deployed as a spoke:

| Resource | Details |
|----------|---------|
| Spoke VNet | 10.101.0.0/16 (peered to hub) |
| Backend | Azure Container Apps (FastAPI, 0-3 replicas) |
| Frontend | Azure Static Web Apps (React, global CDN) |
| Secrets | Azure Key Vault (RBAC, network-denied) |
| Logging | Wired to enterprise-logs workspace |
| NSG | HTTPS only, deny all other inbound |

### Post-Deploy: Set Application Secrets
```bash
az containerapp secret set \
  --name milkink-api \
  --resource-group rg-milkink-production-eastus2 \
  --secrets \
    secret-key=$(openssl rand -hex 32) \
    database-url="YOUR_SUPABASE_URL" \
    stripe-secret-key="sk_live_..." \
    stripe-webhook-secret="whsec_..." \
    anthropic-api-key="sk-ant-..." \
    frontend-url="https://YOUR_SWA_URL"
```

### GitHub Secrets Required
| Secret | Source |
|--------|--------|
| `AZURE_CLIENT_ID` | App registration for OIDC |
| `AZURE_TENANT_ID` | Azure AD tenant |
| `AZURE_SUBSCRIPTION_ID` | Target subscription |
| `MILKINK_SWA_TOKEN` | `terraform output -raw milkink_swa_token` |

---

## 👤 Author

**Elijah Walker**

**Computer Engineering Student** @ *Prairie View A&M University*

---
