module "storage-account" {
  source   = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-storage_accountV2.git?ref=v1.0.4"

  userDefinedString = "${var.userDefinedString}-sa"
  location = var.location
  env = var.env
  resource_groups = var.resource_groups
  storage_account = var.static_websites.storage_account
  subnets = var.subnets
  private_dns_zone_ids = var.zones
  tags = var.tags
}


module "front_door" {
    source = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-front-door.git?ref=v1.0.0"
    env = var.env
    group = var.group
    project = var.project
    userDefinedString = "${var.userDefinedString}-fd"
    front_door= var.static_websites.front_door
    resource_groups = var.resource_groups
    zones = var.zones
    origin_host_name             = module.storage-account.storage-account-object.primary_web_host
    tags = var.tags
}