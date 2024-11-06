module "storage-account" {
  source   = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-storage_accountV2.git?ref=v1.0.5"

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
    source = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-front-door.git?ref=v1.0.1"
    env = var.env
    group = var.group
    project = var.project
    userDefinedString = "${var.userDefinedString}-fd"
    front_door = var.static_websites.front_door
    resource_groups = var.resource_groups
    zones = var.zones
    origin_host_name             = module.storage-account.storage-account-object.primary_web_host
    tags = var.tags
}

data "azuread_users" "sa-access-group-owners" {
  count = try(var.static_websites.aad_group, null) != null ? 1 : 0
  user_principal_names = var.static_websites.aad_group.owners
}

data "azuread_users" "sa-access-group-members" {
  count = try(var.static_websites.aad_group, null) != null ? 1 : 0
  user_principal_names = var.static_websites.aad_group.members
}

resource "azuread_group" "sa-access-group" {
  count = try(var.static_websites.aad_group, null) != null ? 1 : 0
  display_name = "${var.env}-${var.group}-${var.project}-static-website-access"
  owners = data.azuread_users.sa-access-group-owners[0].object_ids
  members = data.azuread_users.sa-access-group-members[0].object_ids
  security_enabled = true
  prevent_duplicate_names = true
}

resource "azurerm_role_assignment" "sa-blob-contributor" {
  count = try(var.static_websites.aad_group, null) != null ? 1 : 0
  scope = module.storage-account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id = azuread_group.sa-access-group[0].id
}