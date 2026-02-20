# ═══════════════════════════════════════════════════════════════
# MILK & INK STUDIO — Spoke Workload
# Deploys into your existing ALZ as a peered spoke
# ═══════════════════════════════════════════════════════════════

# ── Resource Group ────────────────────────────────────────────
resource "azurerm_resource_group" "milkink" {
  name     = "rg-milkink-${var.environment}-${var.location}"
  location = var.location
  tags     = var.tags
}

# ═══════════════════════════════════════════════════════════════
# SPOKE VNET (Peered to Hub)
# ═══════════════════════════════════════════════════════════════

resource "azurerm_virtual_network" "spoke" {
  name                = "vnet-milkink-spoke-${var.environment}"
  resource_group_name = azurerm_resource_group.milkink.name
  location            = var.location
  address_space       = ["10.101.0.0/16"] # Non-overlapping with hub 10.100.0.0/16
  tags                = var.tags
}

resource "azurerm_subnet" "container_apps" {
  name                 = "snet-container-apps"
  resource_group_name  = azurerm_resource_group.milkink.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.101.1.0/23"] # /23 = 512 IPs for container scaling

  delegation {
    name = "container-apps-delegation"
    service_delegation {
      name    = "Microsoft.App/environments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "snet-private-endpoints"
  resource_group_name  = azurerm_resource_group.milkink.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.101.4.0/24"]
}

# ── VNet Peering: Spoke → Hub ─────────────────────────────────
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = "peer-milkink-to-hub"
  resource_group_name          = azurerm_resource_group.milkink.name
  virtual_network_name         = azurerm_virtual_network.spoke.name
  remote_virtual_network_id    = var.hub_vnet_id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
  allow_gateway_transit        = false
  use_remote_gateways          = false # Set true if you use VPN/ER gateway
}

# ── VNet Peering: Hub → Spoke ─────────────────────────────────
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                         = "peer-hub-to-milkink"
  resource_group_name          = var.hub_rg_name
  virtual_network_name         = var.hub_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.spoke.id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

# ── NSG ───────────────────────────────────────────────────────
resource "azurerm_network_security_group" "milkink" {
  name                = "nsg-milkink-${var.environment}"
  resource_group_name = azurerm_resource_group.milkink.name
  location            = var.location
  tags                = var.tags

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "container_apps" {
  subnet_id                 = azurerm_subnet.container_apps.id
  network_security_group_id = azurerm_network_security_group.milkink.id
}

# ═══════════════════════════════════════════════════════════════
# KEY VAULT (Secrets Management)
# ═══════════════════════════════════════════════════════════════

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "milkink" {
  name                       = "kv-milkink-${var.environment}"
  resource_group_name        = azurerm_resource_group.milkink.name
  location                   = var.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  enable_rbac_authorization  = true
  tags                       = var.tags

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}

# ═══════════════════════════════════════════════════════════════
# CONTAINER APPS ENVIRONMENT (Backend API)
# Logs flow to your existing enterprise Log Analytics workspace
# ═══════════════════════════════════════════════════════════════

resource "azurerm_container_app_environment" "milkink" {
  name                           = "cae-milkink-${var.environment}"
  resource_group_name            = azurerm_resource_group.milkink.name
  location                       = var.location
  log_analytics_workspace_id     = var.log_analytics_workspace_id # Wired to your existing LAW
  infrastructure_subnet_id       = azurerm_subnet.container_apps.id
  internal_load_balancer_enabled = false
  tags                           = var.tags
}

resource "azurerm_container_app" "api" {
  name                         = "milkink-api"
  resource_group_name          = azurerm_resource_group.milkink.name
  container_app_environment_id = azurerm_container_app_environment.milkink.id
  revision_mode                = "Single"
  tags                         = var.tags

  template {
    min_replicas = 0
    max_replicas = 3

    container {
      name   = "milkink-api"
      image  = var.api_image
      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "APP_ENV"
        value = var.environment
      }

      # Secrets injected via Container App secrets (set by CI/CD, not Terraform)
      # SECRET_KEY, DATABASE_URL, STRIPE_SECRET_KEY, etc.

      liveness_probe {
        transport = "HTTP"
        path      = "/api/v1/health"
        port      = 8000
      }

      readiness_probe {
        transport = "HTTP"
        path      = "/api/v1/health"
        port      = 8000
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 8000
    transport        = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

# ═══════════════════════════════════════════════════════════════
# STATIC WEB APP (Frontend)
# ═══════════════════════════════════════════════════════════════

resource "azurerm_static_web_app" "frontend" {
  name                = "swa-milkink-${var.environment}"
  resource_group_name = azurerm_resource_group.milkink.name
  location            = var.location
  sku_tier            = "Free"
  sku_size            = "Free"
  tags                = var.tags
}
