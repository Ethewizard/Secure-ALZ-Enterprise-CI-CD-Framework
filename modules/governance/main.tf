resource "azurerm_management_group_policy_assignment" "enforce_tags" {
  name                 = "enforce-owner-tag"
  management_group_id  = var.management_group_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1e30110a-5ceb-460c-a204-c1a3619c9055"
  display_name         = "Enforce Owner Tag"

  parameters = <<PARAMS
    { "tagName": { "value": "Owner" } }
PARAMS
}
