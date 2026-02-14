
variable "rg_name" {
  type        = string
  description = "The name of the resource group where the VNET will be created."
}

variable "location" {
  type        = string
  description = "The Azure region (e.g., East US 2)."
}

variable "region" {
  type        = string
  description = "A naming label for the network (e.g., 'prod' or 'hub')."
}

variable "address_space" {
  type        = list(string)
  description = "The IP range for the VNET."
  default     = ["10.0.0.0/16"]
}
