module "alz_architecture" {
  source             = "Azure/avm-ptn-alz/azurerm"
  version            = "0.18.0"
  architecture_name  = var.root_id
  # Change this from var.subscription_id to the Tenant Root ID
  parent_resource_id = var.parent_resource_id
  location           = var.location
}
