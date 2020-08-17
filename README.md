# terraform-azurerm-network-security-group

[![Build Status](https://travis-ci.org/Azure/terraform-azurerm-network-security-group.svg?branch=master)](https://travis-ci.org/Azure/terraform-azurerm-network-security-group)

## Create a network security group

This Terraform module deploys a Network Security Group (NSG) in Azure and optionally attach it to the specified vnets.

This module is a complement to the [Azure Network](https://registry.terraform.io/modules/Azure/network/azurerm) module. Use the network_security_group_id from the output of this module to apply it to a subnet in the Azure Network module.
NOTE: We are working on adding the support for applying a NSG to a network interface directly as a future enhancement.

This module includes a a set of pre-defined rules for commonly used protocols (for example HTTP or ActiveDirectory) that can be used directly in their corresponding modules or as independent rules.

## Usage with the generic module in Terraform 0.13

The following example demonstrate how to use the network-security-group module with a combination of predefined and custom rules.

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "my-resources"
  location = "West Europe"
}

module "network-security-group" {
  source                = "Azure/network-security-group/azurerm"
  resource_group_name   = azurerm_resource_group.example.name
  location              = "EastUS" # Optional; if not provided, will use Resource Group location
  security_group_name   = "nsg"
  source_address_prefix = ["10.0.3.0/24"]
  predefined_rules = [
    {
      name     = "SSH"
      priority = "500"
    },
    {
      name              = "LDAP"
      source_port_range = "1024-1026"
    }
  ]

  custom_rules = [
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

  tags = {
    environment = "dev"
    costcenter  = "it"
  }

  depends_on = [azurerm_resource_group.example]
}
```

## Usage with the generic module in Terraform 0.12

The following example demonstrate how to use the network-security-group module with a combination of predefined and custom rules.

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "my-resources"
  location = "West Europe"
}

module "network-security-group" {
  source                = "Azure/network-security-group/azurerm"
  resource_group_name   = azurerm_resource_group.example.name
  location              = "EastUS" # Optional; if not provided, will use Resource Group location
  security_group_name   = "nsg"
  source_address_prefix = ["10.0.3.0/24"]
  predefined_rules = [
    {
      name     = "SSH"
      priority = "500"
    },
    {
      name              = "LDAP"
      source_port_range = "1024-1026"
    }
  ]

  custom_rules = [
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

  tags = {
    environment = "dev"
    costcenter  = "it"
  }
}
```

## Usage with the Application Security Group module in Terraform 0.12

The following example demonstrate how to use the network-security-group module with a combination of predefined and custom rules with ASG source or destination.

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "my-resources"
  location = "West Europe"
}

resource "azurerm_application_security_group" "first" {
  name                = "asg-first"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_application_security_group" "second" {
  name                = "asg-second"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name
}

module "network-security-group" {
  source              = "Azure/network-security-group/azurerm"
  resource_group_name = azurerm_resource_group.example.name
  location            = "eastus"
  security_group_name = "nsg"
  predefined_rules = [
    {
      name                                  = "SSH"
      priority                              = "500"
      source_application_security_group_ids = [azurerm_application_security_group.first.id]
    }
  ]

  custom_rules = [
    {
      name                                       = "myhttp"
      priority                                   = "200"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "tcp"
      destination_port_range                     = "8080"
      description                                = "description-myhttp"
      destination_application_security_group_ids = [azurerm_application_security_group.second.id]
    }
  ]
  tags = {
    environment = "dev"
    costcenter  = "it"
  }
}
```

## Usage with the pre-defined module in Terraform 0.12

The following example demonstrate how to use the pre-defined HTTP module with a custom rule for ssh.

```hcl
resource "azurerm_resource_group" "example" {
  name     = "my-resources"
  location = "West Europe"
}

module "network-security-group" {
  source              = "Azure/network-security-group/azurerm//modules/HTTP"
  resource_group_name = azurerm_resource_group.example.name
  security_group_name = "nsg"
  custom_rules = [
    {
      name                   = "ssh"
      priority               = "200"
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "tcp"
      destination_port_range = "22"
      source_address_prefix  = "VirtualNetwork"
      description            = "ssh-for-vm-management"
    }
  ]
  tags = {
    environment = "dev"
    costcenter  = "it"
  }
}
```

## Test

### Configurations

- [Configure Terraform for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)

We provide 2 ways to build, run, and test the module on a local development machine.  [Native (Mac/Linux)](#native-maclinux) or [Docker](#docker).

### Native (Mac/Linux)

#### Prerequisites

- [Ruby **(~> 2.3)**](https://www.ruby-lang.org/en/downloads/)
- [Bundler **(~> 1.15)**](https://bundler.io/)
- [Terraform **(~> 0.11.7)**](https://www.terraform.io/downloads.html)
- [Golang **(~> 1.10.3)**](https://golang.org/dl/)

#### Environment setup

We provide simple script to quickly set up module development environment:

```sh
$ curl -sSL https://raw.githubusercontent.com/Azure/terramodtest/master/tool/env_setup.sh | sudo bash
```

#### Run test

Then simply run it in local shell:

```sh
$ cd $GOPATH/src/{directory_name}/
$ bundle install
$ rake build
$ rake full
```

### Docker

We provide a Dockerfile to build a new image based `FROM` the `mcr.microsoft.com/terraform-test` Docker hub image which adds additional tools / packages specific for this module (see Custom Image section).  Alternatively use only the `mcr.microsoft.com/terraform-test` Docker hub image [by using these instructions](https://github.com/Azure/terraform-test).

#### Prerequisites

- [Docker](https://www.docker.com/community-edition#/download)

#### Custom Image

This builds the custom image:

```sh
$ docker build --build-arg BUILD_ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID --build-arg BUILD_ARM_CLIENT_ID=$ARM_CLIENT_ID --build-arg BUILD_ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET --build-arg BUILD_ARM_TENANT_ID=$ARM_TENANT_ID -t azure-network-security-group .
```

This runs the build and unit tests:

```sh
$ docker run --rm azure-network-security-group /bin/bash -c "bundle install && rake build"
```

This runs the end to end tests:

```sh
$ docker run --rm azure-network-security-group /bin/bash -c "bundle install && rake e2e"
```

This runs the full tests:

```sh
$ docker run --rm azure-network-security-group /bin/bash -c "bundle install && rake full"
```

## Authors

Originally created by [Damien Caro](http://github.com/dcaro) and [Richard Guthrie](https://github.com/rguthriemsft).

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit [https://cla.microsoft.com](https://cla.microsoft.com).

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## License

[MIT](LICENSE)
