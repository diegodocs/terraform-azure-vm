terraform {

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }

  backend "azurerm" {
    resource_group_name  = "dev-governance-rg-001"
    storage_account_name = "sadevtfstate002"
    container_name       = "tfstate"
    key                  = "dev-starapp-001.tfstate"
  }
}

provider "azurerm" {
  features {}
}