[![Terraform-Module-Azure-VM-Package](https://github.com/diegodocs/terraform-azure-vm/actions/workflows/terraform-module-azure-vm-package.yml/badge.svg)](https://github.com/diegodocs/terraform-azure-vm/actions/workflows/terraform-module-azure-vm-package.yml)

# Module Terraform-Azure-Vm

## Deploys 1+ Virtual Machines to your provided VNet

This Terraform module deploys Virtual Machines in Azure with the following characteristics:

- Ability to specify a Windows Virtual Machine
- All VMs use [managed disks](https://azure.microsoft.com/services/managed-disks/)
- VM nics attached to a single virtual network subnet of your choice (existing) via `var.vnet_name` and `var.subnet_name`.

## Outputs

- vm_ids = Array of Virtual machine ids created.

## Usage example

```hcl
module "example_001" {
    
    source = "./modules/vm"
    
    #VM        
    business_product_name = "example"
    owner      = "dev@test.io"
    costcenter = "123456-001"
    monitoring = true
    env        = "dev"
    suffix     = "001"

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
          
}
```

```yml
- name: Download artifact    
    uses: dawidd6/action-download-artifact@v2
    with:   
        repo: diegodocs/terraform-module-azure-vm     
        workflow: terraform-module-azure-vm-package.yml     
        name: terraform-module-azure-vm-1.0.0.4
        path: ./modules/vm 
        github_token: ${{secrets.PRIVATE_REPO_TOKEN}} 
    
```

## You shouldn't find

- Secrets or sensitive info hardcoded committed to source control.
- Unnecessary project or library references or third party frameworks.
- Binaries
