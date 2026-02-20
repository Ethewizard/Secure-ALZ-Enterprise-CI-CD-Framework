resource "azurerm_resource_group" "mgmt" {
  name     = "rg-management-${var.location}"
  location = var.location
}

resource "azurerm_log_analytics_workspace" "logs" {
  name                = "enterprise-logs"
  location            = azurerm_resource_group.mgmt.location
  resource_group_name = azurerm_resource_group.mgmt.name
  sku                 = "PerGB2018"
}
