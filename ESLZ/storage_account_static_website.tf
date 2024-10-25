variable "static_websites" {
  description = "Static websites to deploy"
  type        = any
  default     = {}
}

module "storage-account" {
  source   = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-storage_accountV2.git?ref=v1.0.4"
  for_each = var.static_websites

  userDefinedString = "${each.key}-sa"
  location = var.location
  env = var.env
  resource_groups = local.resource_groups_all
  storage_account = each.value.storage_account
  subnets = local.subnets
  #private_dns_zone_ids = local.zones
  tags = var.tags
}


module "front_door" {
    for_each = var.static_websites
    source = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-front-door.git"
    env = var.env
    group = var.group
    project = var.project
    userDefinedString = "${each.key}-fd"
    front_door= each.value.front_door
    resource_groups = local.resource_groups_all
    zones = local.zones
    origin_host_name             = module.storage-account[each.key].storage-account-object.primary_web_host
    tags = var.tags
}