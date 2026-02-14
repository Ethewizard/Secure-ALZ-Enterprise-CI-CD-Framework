resource "azurerm_virtual_network" "hub" {
  name                = "vnet-hub-${var.region}"
  address_space       = ["10.100.0.0/16"]
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet" # Required name for VPN/ExpressRoute
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.100.1.0/24"]
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet" # Required name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.100.2.0/24"]
}
