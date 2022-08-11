module "deploy_starapp_001" {

  source = "./modules/vm"

  #VM        
  business_product_name = "starapp"

  #NETWORK
  vnet_resource_group_name = "dev-governance-rg-001"
  vnet_name                = "dev-br-vnet-001"
  subnet_name              = "dev-br-snet-001"

  #SIZE                       
  vm_size      = "Standard_B1s"
  vm_publisher = "MicrosoftWindowsServer"
  vm_offer     = "WindowsServer"
  vm_sku       = "2022-Datacenter"
  vm_version   = "latest"

  #GOVERNANCE
  owner      = "devteam@test.io"
  costcenter = "123456-001"
  monitoring = true
  env        = "dev"
  suffix     = "001"
}