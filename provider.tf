terraform {

  required_version = ">=0.12"
  
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.9"
    }
  }

  backend "azurerm" {
      resource_group_name  = "#{AzureRmResourceGroupName}#"
      storage_account_name = "#{AzureRmStorageAccountName}#"
      container_name       = "#{AzureRmContainerName}#"
      key                  = "#{AzureRmStateFile}#"
      access_key           = "#{AzureRmAccessKey}#"
  }  
}

provider "azurerm" {
  features {}
}
