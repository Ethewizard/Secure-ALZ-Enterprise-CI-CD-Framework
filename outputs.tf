output "management_group_ids" {
  value = module.identity_layer.management_group_ids
}

output "hub_vnet_id" {
  value = module.connectivity_layer.hub_vnet_id
}

output "log_analytics_workspace_id" {
  value = module.management_layer.log_analytics_workspace_id
}

# ── Milk & Ink Workload Outputs ───────────────────────────────

output "milkink_api_fqdn" {
  value       = module.milkink_workload.container_app_fqdn
  description = "Milk & Ink API URL."
}

output "milkink_frontend_url" {
  value       = module.milkink_workload.static_web_app_url
  description = "Milk & Ink frontend URL."
}

output "milkink_resource_group" {
  value       = module.milkink_workload.resource_group_name
  description = "Milk & Ink resource group."
}

output "milkink_key_vault" {
  value       = module.milkink_workload.key_vault_name
  description = "Milk & Ink Key Vault."
}

output "milkink_spoke_vnet_id" {
  value       = module.milkink_workload.spoke_vnet_id
  description = "Milk & Ink spoke VNet ID."
}
