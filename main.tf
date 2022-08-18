locals {
  app_name = "${var.env}-${var.business_product_name}-${var.suffix}"
  tags = {
    "generated-by"     = "github-actions|terraform"
    "build-version"    = "1.0.0.0"
    "build-timestamp"  = timestamp()
    "owner"            = var.owner
    "costcenter"       = var.costcenter
    "monitoring"       = var.monitoring
    "env"              = var.env
    "business_product" = var.business_product_name
  }
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
  name     = "${local.app_name}-rg"
  location = var.resource_location

  tags = local.tags
}

resource "azurerm_network_interface" "nic" {
  name                = "${local.app_name}-vm-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "${local.app_name}-vm-nic-config"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [
    resource.azurerm_resource_group.main
  ]
}

resource "azurerm_virtual_machine" "vm" {  
  name                             = "${local.app_name}-vm"
  location                         = azurerm_resource_group.main.location
  resource_group_name              = azurerm_resource_group.main.name
  network_interface_ids            = [azurerm_network_interface.nic.id]
  vm_size                          = var.vm_size
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.vm_publisher
    offer     = var.vm_offer
    sku       = var.vm_sku
    version   = var.vm_version
  }

  storage_os_disk {
    name              = "${local.app_name}-vm-disk-os"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  storage_data_disk {
    name              = "${local.app_name}-vm-disk-data"
    disk_size_gb      = var.vm_disk_data_size_gb
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
  }

  os_profile {
    computer_name  = local.app_name
    admin_username = var.vm_admin_username
    admin_password = var.vm_admin_password
  }

  os_profile_windows_config {
    enable_automatic_upgrades = true
  }

  tags = local.tags

  depends_on = [
    resource.azurerm_network_interface.nic
  ]
}

resource "azurerm_virtual_machine_extension" "extension_antimalware" {
  name                       = "${local.app_name}-vm-extension-antimalware"
  virtual_machine_id         = azurerm_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.Security"
  type                       = "IaaSAntimalware"
  type_handler_version       = "2.0"
  auto_upgrade_minor_version = true
}

resource "azurerm_recovery_services_vault" "vault" {
  name                = "${local.app_name}-vm-backup-kv"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"
  soft_delete_enabled = true
}

resource "azurerm_backup_policy_vm" "vm_backup_policy" {
  name                = "${local.app_name}-vm-backup-policy"
  resource_group_name = azurerm_resource_group.main.name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 10
  }

  retention_weekly {
    count    = 42
    weekdays = ["Sunday", "Wednesday", "Friday", "Saturday"]
  }

  retention_monthly {
    count    = 7
    weekdays = ["Sunday", "Wednesday"]
    weeks    = ["First", "Last"]
  }

  retention_yearly {
    count    = 77
    weekdays = ["Sunday"]
    weeks    = ["Last"]
    months   = ["January"]
  }
}

resource "azurerm_backup_protected_vm" "vm_protected_backup" {
  resource_group_name = azurerm_resource_group.main.name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
  source_vm_id        = azurerm_virtual_machine.vm.id
  backup_policy_id    = azurerm_backup_policy_vm.vm_backup_policy.id
}