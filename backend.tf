terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "enterpriseauditstate" # Replace with your unique name
    container_name       = "tfstate"
    key                  = "landingzone.tfstate"
    use_oidc             = true
  }
}
