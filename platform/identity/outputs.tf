output "management_group_ids" {
  # Fix: Updated to the correct AVM output name
  value       = module.alz_architecture.management_group_resource_ids
  description = "A map of the Management Group names to their resource IDs."
}
