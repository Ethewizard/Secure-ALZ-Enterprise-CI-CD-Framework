---

# 🌐 Azure Landing Zone: Enterprise CI/CD Framework

An enterprise-scale, secure, and fully automated Azure Landing Zone (ALZ) deployment. This project leverages **2026 Industry Standards** to provide a governed foundation for critical infrastructure workloads, inspired by the operational needs of the **critical infrastructure entities**.

---

## 🚀 Key Features

* **Zero-Trust Authentication:** Uses **OpenID Connect (OIDC)** with GitHub Actions to eliminate long-lived secrets and passwords.
* **Azure Verified Modules (AVM):** Built using the 2026 modular standard for high reliability and consistent performance.
* **Policy-Driven Governance:** Automated guardrails ensure compliance (e.g., NERC CIP alignment) from the moment a resource is created.
* **Automated CI/CD:** Integrated **GitHub Actions** pipelines for automated Planning, Application, and Nightly Drift Detection.
* **State Management:** Secure remote state tracking with **Azure Storage** and blob-locking.

---

## 🏗️ Architecture Overview

The landing zone follows a **Platform vs. Workload** separation, even within a single-subscription development environment:

1. **Identity & Governance:** A Management Group hierarchy that organizes resources and enforces global security policies.
2. **Connectivity (Hub & Spoke):** A central "Hub" Virtual Network containing shared services like Azure Firewall and VPN Gateways.
3. **Management:** A centralized Log Analytics Workspace for unified auditing, monitoring, and SIEM (Sentinel) integration.

---

## 📂 Project Structure

```text
azure-landing-zone-terraform-cicd/
├── .github/workflows/      # CI/CD Pipelines (Plan, Apply, Drift)
├── modules/                # Reusable custom blueprints (Networking, Tags)
├── platform/               # Core Landing Zone layers (Identity, Connectivity)
├── scripts/                # Pre-deployment validation & linting
├── providers.tf            # AzureRM and ALZ provider configurations
├── backend.tf              # Remote state configuration (OIDC enabled)
└── terraform.tfvars        # Environment-specific variables (Ignored by Git)

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
git clone https://github.com/ethewizard/ALZ-terraform.git

```


2. Initialize the project:
```bash
terraform init

```


3. Run a preview:
```bash
terraform plan

```



---

## 🔐 Security & Compliance

For critical infrastructure entities, security is non-negotiable. This project implements:

* **Federated Identity:** GitHub Actions is granted temporary, short-lived tokens to deploy code, reducing the "Attack Surface" of a potential credential leak.
* **Resource Guarding:** Every deployment includes a `pre-deploy-check.sh` script to ensure code follows organizational formatting and security standards before hitting the cloud.
* **Drift Detection:** Nightly scans ensure that "ClickOps" (manual portal changes) are flagged and corrected to maintain the environment's integrity.

---

## 👤 Author

**Elijah Walker**

**Computer Engineering Student** @ *Prairie View A&M University*

---
