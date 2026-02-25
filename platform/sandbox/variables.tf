# ═══════════════════════════════════════════════════════════════
# SANDBOX — platform/sandbox/variables.tf
# ═══════════════════════════════════════════════════════════════

variable "default_location" {
  description = "Azure region for sandbox resources"
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}

variable "admin_password" {
  description = "Admin password for the sandbox VM"
  type        = string
  sensitive   = true
}
