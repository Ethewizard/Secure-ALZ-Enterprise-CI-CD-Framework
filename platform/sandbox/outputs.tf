# ═══════════════════════════════════════════════════════════════
# SANDBOX — platform/sandbox/outputs.tf
# ═══════════════════════════════════════════════════════════════

output "resource_group_name" {
  description = "Name of the sandbox resource group"
  value       = azurerm_resource_group.sandbox.name
}

output "vm_name" {
  description = "Name of the sandbox VM"
  value       = azurerm_linux_virtual_machine.sandbox.name
}

output "vm_private_ip" {
  description = "Private IP of the sandbox VM"
  value       = azurerm_network_interface.sandbox_vm.private_ip_address
}
