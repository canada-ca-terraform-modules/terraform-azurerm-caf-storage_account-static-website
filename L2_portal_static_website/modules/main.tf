terraform {
  required_providers {
    azurerm = {
      # https://github.com/terraform-providers/terraform-provider-azurerm
      source  = "hashicorp/azurerm"
      version = "~> 4.0.0"
    }
    azuread = {
      # https://github.com/hashicorp/terraform-provider-azuread
      source  = "hashicorp/azuread"
      version = "~> 2.22.0"
    }
  }
  required_version = "= 1.9.1"
}

provider "azurerm" {
  features {}
}