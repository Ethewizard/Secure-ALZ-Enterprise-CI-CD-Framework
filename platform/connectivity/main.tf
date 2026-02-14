resource "azurerm_resource_group" "net" {
  name     = "rg-connectivity-${var.location}"
  location = var.location
}

module "hub_network" {
  source              = "../../modules/networking" # Points to your local module
  rg_name             = azurerm_resource_group.net.name
  location            = var.location
  region              = "prod"
}
