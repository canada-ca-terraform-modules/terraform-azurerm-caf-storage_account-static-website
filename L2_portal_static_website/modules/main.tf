terraform {
  required_providers {
    azurerm = {
      # https://github.com/terraform-providers/terraform-provider-azurerm
      source  = "hashicorp/azurerm"
      version = "~> 4.0.0"
    }
  }
  required_version = ">= 1.7.3, <2.0.0" # Ensure we get a signal for a major version bump to 2.x
}

provider "azurerm" {
  features {}
}