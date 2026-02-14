variable "management_group_id" {
  type        = string
  description = "The ID of the Management Group where policies will be assigned."
}

variable "miso_compliance_level" {
  type        = string
  description = "The strictness of the policy (e.g., 'Standard' or 'High-Regulated')."
  default     = "Standard"
}

variable "owner_tag_value" {
  type        = string
  description = "The default value for the mandatory 'Owner' tag."
  default     = "Cloud-Ops-Team"
}
