# terraform-azurerm-network-security-group #

[![Build Status](https://travis-ci.org/Azure/terraform-azurerm-network-security-group.svg?branch=master)](https://travis-ci.org/Azure/terraform-azurerm-network-security-group)

Create a network security group
-------------------------------

This Terraform module deploys a Network Security Group in Azure and optionally attach it to the specified vnets.

This module is a complement to the [Azure Network](https://registry.terraform.io/modules/Azure/network/azurerm) module. Use the network_security_group_id from the output of this module to apply it to a subnet in the Azure Network module.
NOTE: We are working on adding the support for network interface in the future.

This module includes a a set of pre-defined rules for commonly used protocols (for example HTTP or ActiveDirectory) that can be used directly in their corresponding modules or as independent rules.

Usage with the generic module:
------------------------------

The following example demonstrate how to use the network-security-group module with a combination of predefined and custom rules.

```hcl
module "network-security-group" {
    source                     = "Azure/network-security-group/azurerm"
    resource_group_name        = "nsg-resource-group"
    location                   = "westus"
    security_group_name        = "nsg"
    predefined_rules           = [
      {
        name                   = "SSH"
        priority               = "500"
        source_address_prefix  = ["10.0.3.0/24"]
      },
      {
        name                   = "LDAP"
        source_port_range      = "1024-1026"
      }
    ]
    custom_rules               = [
      {
        name                   = "myhttp"
        priority               = "200"
        direction              = "Inbound"
        access                 = "Allow"
        protocol               = "tcp"
        destination_port_range = "8080"
        description            = "description-myhttp"
      }
    ]
    tags                       = {
                                   environment = "dev"
                                   costcenter  = "it"
                                 }
}
```

Usage with the pre-defined module:
----------------------------------

The following example demonstrate how to use the pre-defined HTTP module with a custom rule for ssh.

```hcl
module "network-security-group" {
    source                     = "Azure/network-security-group/azurerm//modules/HTTP"
    resource_group_name        = "nsg-resource-group"
    location                   = "westus"
    security_group_name        = "nsg"
    custom_rules               = [
      {
        name                   = "ssh"
        priority               = "200"
        direction              = "Inbound"
        access                 = "Allow"
        protocol               = "tcp"
        destination_port_range = "22"
        source_address_prefix  = ["VirtualNetwork"]
        description            = "ssh-for-vm-management"
      }
    ]
    tags                       = {
                                  environment = "dev"
                                  costcenter  = "it"
                                 }
}
```

## Authors

Originally created by [Damien Caro](http://github.com/dcaro) and [Richard Guthrie](https://github.com/rguthriemsft).

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
