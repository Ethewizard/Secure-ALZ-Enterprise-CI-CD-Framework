output "hub_vnet_id" {
  # Fix: Ensure your networking module exports 'vnet_id'
  value = module.hub_network.vnet_id
}
