locals {  
  app_name = "${var.env}-${var.business_product_name}-001"
}

data "azurerm_virtual_network" "vnet" {  
  name                = var.vnet_name
  resource_group_name = var.vnet_resource_group_name  
}

data "azurerm_subnet" "subnet" {  
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name   
  resource_group_name  = var.vnet_resource_group_name  
}

resource "azurerm_resource_group" "main" {  
  name      = "${local.app_name}-rg"  
  location  = var.resource_location 

  tags = {
    "generated-by" = "github-actions|terraform"
    "owner"        = var.owner
    "costcenter"   = var.costcenter
    "monitoring"   = var.monitoring
    "env"          = var.env
  }
}

resource "azurerm_network_interface" "nic" {
  name                 = "${local.app_name}-vm-nic"
  count                = var.vm_count
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name

  ip_configuration {
    name                            = "${local.app_name}-vm-nic-config"
    subnet_id                       = data.azurerm_subnet.subnet.id
    private_ip_address_allocation   = "dynamic"    
  }    
}

resource "azurerm_virtual_machine" "vm" {
  count                             = 1
  name                              = "${local.app_name}-vm"
  location                          = azurerm_resource_group.main.location
  resource_group_name               = azurerm_resource_group.main.name
  network_interface_ids             = ["${element(azurerm_network_interface.nic.*.id, count.index+1)}"]
  vm_size                           = var.vm_size
  delete_os_disk_on_termination     = true
  delete_data_disks_on_termination  = true

  storage_image_reference {
    publisher = var.vm_publisher
    offer     = var.vm_offer
    sku       = var.vm_sku
    version   = var.vm_version
  }

  storage_os_disk {
    name                = "${local.app_name}-vm-disk-os"
    caching             = "ReadWrite"
    managed_disk_type   = "Standard_LRS"
    create_option       = "FromImage"
  }

  storage_data_disk {    
    name                = "${local.app_name}-vm-disk-data"
    disk_size_gb        = var.vm_disk_data_size_gb
    managed_disk_type   = "Standard_LRS"
    create_option       = "Empty"
    lun                 = 0
  }

  os_profile {
    computer_name  = "${local.app_name}"
    admin_username = var.vm_admin_username
    admin_password = var.vm_admin_password
  }

  os_profile_windows_config {
    enable_automatic_upgrades = true
  }

  tags = {
    "generated-by" = "github-actions|terraform"
    "owner"        = var.owner
    "costcenter"   = var.costcenter
    "monitoring"   = var.monitoring
    "env"          = var.env
    "osinfo"       = "${var.vm_offer}|${var.vm_sku}"
  }

  depends_on = [    
    resource.azurerm_network_interface.nic
  ]
}