output "log_analytics_workspace_id" {
  # Fix: Ensure this matches your azurerm_log_analytics_workspace resource name
  value = azurerm_log_analytics_workspace.logs.id
}
