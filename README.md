# Module Terraform-Azure-Vm

## Deploys 1+ Virtual Machines to your provided VNet

This Terraform module deploys Virtual Machines in Azure with the following characteristics:

- Ability to specify a Windows Virtual Machine
- All VMs use [managed disks](https://azure.microsoft.com/services/managed-disks/)
- VM nics attached to a single virtual network subnet of your choice (existing) via `var.vnet_name` and `var.subnet_name`.

## Outputs:
- vm_ids = Array of Virtual machine ids created.

## Usage example in Terraform 0.14

```hcl
module "deploy_starapp" {
    
    source = "./modules/vm"
    
    #VM        
    business_product_name       = "starapp"
    
    #NETWORK
    vnet_resource_group_name    = "dev-governance-rg-001"
    vnet_name                   = "dev-br-vnet-001"
    subnet_name                 = "dev-br-snet-001"
    
    #SIZE                       
    vm_size                     = "Standard_B1s"
    vm_publisher                = "MicrosoftWindowsServer"
    vm_offer                    = "WindowsServer"
    vm_sku                      = "2019-Datacenter"
    vm_version                  = "latest"        

    #GOVERNANCE
    owner                       = "devteam@test.io"
    costcenter                  = "123456-001"  
    monitoring                  = true  
    env                         = "dev"
          
}
```