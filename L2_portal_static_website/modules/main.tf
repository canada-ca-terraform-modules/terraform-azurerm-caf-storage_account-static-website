terraform {
  required_providers {
    azurerm = {
      # https://github.com/terraform-providers/terraform-provider-azurerm
      source  = "hashicorp/azurerm"
      version = "~> 4.0.0"
    }
  }
  required_version = ">= 1.7.3"
}

provider "azurerm" {
  features {}
}