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
