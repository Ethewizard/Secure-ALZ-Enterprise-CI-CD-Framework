terraform {
  required_version = ">= 1.14.5"

  required_providers {
    # 1. The standard Azure Resource Manager provider
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.35" 
    }
    # 2. The specific Azure Landing Zone provider
    alz = {
      source  = "azure/alz"     
      version = "~> 0.20.0"     # This is currently the latest stable for 2026
    }
    # 3. Often required for ALZ modules in 2026
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.4"
    }
  }
}

provider "azurerm" {
  features {}
  use_oidc = true 
}
provider "alz" {
  library_references = [
    {
      path = "platform/alz"
      ref  = "2026.01.1"
    }
  ]
}
