output "management_group_ids" {
  value = module.identity_layer.management_group_ids
}

output "hub_vnet_id" {
  value = module.connectivity_layer.hub_vnet_id
}

output "log_analytics_workspace_id" {
  value = module.management_layer.log_analytics_workspace_id
}

output "sandbox_vm_name" {
  value = module.sandbox.vm_name
}

output "sandbox_vm_private_ip" {
  value = module.sandbox.vm_private_ip
}
