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
    key                  = "dev-starapp-001.tfsate"
    access_key           = "pgea2upiLfhikrXierRqho4mI6OsNMPcH0dy4A5/MoPdfgd16W7aTZSB8YvAsxL4kax2VcpSAzMX+ASt9Y3THg=="
  }
}

provider "azurerm" {
  features {}
}