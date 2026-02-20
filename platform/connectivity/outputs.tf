output "hub_vnet_id" {
  # Fix: Ensure your networking module exports 'vnet_id'
  value = module.hub_network.vnet_id
}

output "hub_vnet_name" {
  value       = module.hub_network.vnet_name
  description = "Hub VNet name (needed for spoke peering)."
}
