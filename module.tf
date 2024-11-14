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

data "azuread_service_principal" "devops-sp" {
  display_name = "${var.env}_${var.group}_${var.project}_devops_sp"
}

resource "azurerm_role_assignment" "blob-contributor-devops-sp" {
  scope = module.storage-account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id = data.azuread_service_principal.devops-sp.id
}