variable "root_id" {
  type        = string
  description = "The prefix for all resources "
  default     = "alz"
}

variable "root_name" {
  type        = string
  description = "The display name for your enterprise hierarchy."
  default     = "Secure Enterprise"
}

variable "default_location" {
  type        = string
  description = "The primary Azure region."
  default     = "eastus2"
}

variable "subscription_id" {
  type        = string
  description = "The single Azure Subscription ID for all resources."
}

variable "tags" {
  type = map(string)
  default = {
    Project   = "Azure Landing Zone"
    ManagedBy = "Terraform"
    Owner     = "Cloud-Team"
  }
}
variable "parent_resource_id" {
  type        = string
  description = "The ID of the parent resource"
}

variable "tenant_id" {
  type = string

}
