variable "static_websites" {
  description = "Static websites to deploy"
  type        = any
  default     = {}
}


module "static_websites" {
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-storage_account-static-website.git?ref=v1.0.3"
  for_each = var.static_websites
  userDefinedString = each.key
  location = var.location
  env = var.env
  group = var.group
  project = var.project
  resource_groups = local.resource_groups_all
  zones = local.zones
  subnets = local.subnets
  static_websites = each.value
  tags = var.tags
}
