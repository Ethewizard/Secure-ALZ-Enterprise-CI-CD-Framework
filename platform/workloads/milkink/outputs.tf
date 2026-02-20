# ═══════════════════════════════════════════════════════════════
# MILK & INK SPOKE — Outputs
# ═══════════════════════════════════════════════════════════════

output "resource_group_name" {
  value       = azurerm_resource_group.milkink.name
  description = "Milk & Ink workload resource group."
}

output "spoke_vnet_id" {
  value       = azurerm_virtual_network.spoke.id
  description = "Spoke VNet resource ID."
}

output "container_app_fqdn" {
  value       = azurerm_container_app.api.ingress[0].fqdn
  description = "Public FQDN of the Milk & Ink API backend."
}

output "container_app_env_name" {
  value       = azurerm_container_app_environment.milkink.name
  description = "Container Apps Environment name (used by CI/CD)."
}

output "static_web_app_url" {
  value       = azurerm_static_web_app.frontend.default_host_name
  description = "Public URL of the Milk & Ink frontend."
}

output "static_web_app_api_token" {
  value       = azurerm_static_web_app.frontend.api_key
  description = "Deployment token for Static Web App (store as GitHub secret)."
  sensitive   = true
}

output "key_vault_name" {
  value       = azurerm_key_vault.milkink.name
  description = "Key Vault name for secrets management."
}
