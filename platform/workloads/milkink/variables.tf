# ═══════════════════════════════════════════════════════════════
# MILK & INK SPOKE — Input Variables
# ═══════════════════════════════════════════════════════════════

# ── Passed from root main.tf ──────────────────────────────────
variable "subscription_id" {
  type        = string
  description = "Azure subscription ID."
}

variable "location" {
  type        = string
  description = "Azure region (inherited from var.default_location)."
}

variable "environment" {
  type        = string
  description = "Environment name (production, staging, dev)."
  default     = "production"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags (inherited from root)."
  default     = {}
}

# ── Wired from other platform layers ─────────────────────────
variable "hub_vnet_id" {
  type        = string
  description = "Resource ID of the hub VNet (from connectivity_layer output)."
}

variable "hub_vnet_name" {
  type        = string
  description = "Name of the hub VNet (for hub→spoke peering)."
}

variable "hub_rg_name" {
  type        = string
  description = "Resource group containing the hub VNet."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Resource ID of the shared Log Analytics workspace (from management_layer output)."
}

# ── App-specific ──────────────────────────────────────────────
variable "api_image" {
  type        = string
  description = "Container image for the Milk & Ink API backend."
  default     = "ghcr.io/ethewizard/milkink-api:latest"
}
