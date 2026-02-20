locals {
  # Standardized naming convention for Enterprise-style resources
  resource_prefix = "${var.root_id}-${var.default_location}"
  
  # Configuration object to pass to sub-modules
  global_settings = {
    root_id    = var.root_id
    location   = var.default_location
    tags       = var.tags
  }
}
