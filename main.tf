# 1. Build the Hierarchy (Management Groups & Policies)
data "azurerm_client_config" "current" {}
module "identity_layer" {
  source             = "./platform/identity"
  subscription_id    = var.subscription_id
  location           = var.default_location
  root_id            = var.root_id
  root_name          = var.root_name
  tenant_id          = var.tenant_id
  parent_resource_id = var.parent_resource_id
}

# 2. Build the Shared Services (Logging & Backup)
module "management_layer" {
  source          = "./platform/management"
  subscription_id = var.subscription_id
  location        = var.default_location
  depends_on      = [module.identity_layer]
}

# 3. Build the Network (VNETs & Hub)
module "connectivity_layer" {
  source          = "./platform/connectivity"
  subscription_id = var.subscription_id
  location        = var.default_location
  depends_on      = [module.management_layer]
}

