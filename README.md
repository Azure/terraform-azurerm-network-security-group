# terraform-azurerm-network-security-group

## Notice on Upgrade to V4.x

We've added a CI pipeline for this module to speed up our code review and to enforce a high code quality standard, if you want to contribute by submitting a pull request, please read [Pre-Commit & Pr-Check & Test](#Pre-Commit--Pr-Check--Test) section, or your pull request might be rejected by CI pipeline.

A pull request will be reviewed when it has passed Pre Pull Request Check in the pipeline, and will be merged when it has passed the acceptance tests. Once the CI pipeline failed, please read the pipeline's output, thanks for your cooperation.

V4.0.0 is a major version upgrade. Extreme caution must be taken during the upgrade to avoid resource replacement and downtime by accident.

Running `terraform plan` first to inspect the plan is strongly advised.


### Terraform and terraform-provider-azurerm version restrictions

Now Terraform core's version is v1.x and terraform-provider-azurerm's version is v3.x.

## Example Usage

Please refer to the sub folders under `examples` folder. You can execute `terraform apply` command in `examples`'s sub folder to try the module. These examples are tested against every PR with the [E2E Test](#Pre-Commit--Pr-Check--Test).

## Create a network security group

This Terraform module deploys a Network Security Group (NSG) in Azure and optionally attach it to the specified vnets.

This module is a complement to the [Azure Network](https://registry.terraform.io/modules/Azure/network/azurerm) module. Use the network_security_group_id from the output of this module to apply it to a subnet in the Azure Network module.
NOTE: We are working on adding the support for applying a NSG to a network interface directly as a future enhancement.

This module includes a a set of pre-defined rules for commonly used protocols (for example HTTP or ActiveDirectory) that can be used directly in their corresponding modules or as independent rules.

## Usage with the generic module in Terraform 0.13

The following example demonstrate how to use the network-security-group module with a combination of predefined and custom rules.

~> **NOTE:** `source_address_prefix` is defined differently in `predefined_rules` and `custom_rules`. 
`predefined_rules` uses `var.source_address_prefix` defined in the module.`var.source_address_prefix` is of type list(string), but allowed only one element (CIDR, `*`, source IP range or Tags). For more source_address_prefixes, please use `var.source_address_prefixes`. The same for `var.destination_address_prefix` in `predefined_rules`.
`custom_rules` uses `source_address_prefix` defined in the block `custom_rules`. `source_address_prefix` is of type string (CIDR, `*`, source IP range or Tags). For more source_address_prefixes, please use `source_address_prefixes` in block `custom_rules`. The same for `destination_address_prefix` in `custom_rules`.

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
      name                   = "myssh"
      priority               = 201
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "tcp"
      source_port_range      = "*"
      destination_port_range = "22"
      source_address_prefix  = "10.151.0.0/24"
      description            = "description-myssh"
    },
    {
      name                    = "myhttp"
      priority                = 200
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "tcp"
      source_port_range       = "*"
      destination_port_range  = "8080"
      source_address_prefixes = ["10.151.0.0/24", "10.151.1.0/24"]
      description             = "description-http"
    },
  ]

  tags = {
    environment = "dev"
    costcenter  = "it"
  }

  depends_on = [azurerm_resource_group.example]
}
```

## Usage with for_each iteration instead of count

~> **IMPORTANT NOTES:** 

`var.custom_rules` -> `name` is a mandatory attribute and should be unique across rules.

`var.predefined_rules` -> `priority` is a mandatory attribute and should be unique across rules.

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
  use_for_each          = true
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
      name                   = "myssh"
      priority               = 201
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "tcp"
      source_port_range      = "*"
      destination_port_range = "22"
      source_address_prefix  = "10.151.0.0/24"
      description            = "description-myssh"
    },
    {
      name                    = "myhttp"
      priority                = 200
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "tcp"
      source_port_range       = "*"
      destination_port_range  = "8080"
      source_address_prefixes = ["10.151.0.0/24", "10.151.1.0/24"]
      description             = "description-http"
    },
  ]

  tags = {
    environment = "dev"
    costcenter  = "it"
  }

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
  source              = "Azure/network-security-group/azurerm//examples/HTTP"
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

## Enable or disable tracing tags

We're using [BridgeCrew Yor](https://github.com/bridgecrewio/yor) and [yorbox](https://github.com/lonegunmanb/yorbox) to help manage tags consistently across infrastructure as code (IaC) frameworks. In this module you might see tags like:

```hcl
resource "azurerm_resource_group" "rg" {
  location = "eastus"
  name     = random_pet.name
  tags = merge(var.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_git_commit           = "3077cc6d0b70e29b6e106b3ab98cee6740c916f6"
    avm_git_file             = "main.tf"
    avm_git_last_modified_at = "2023-05-05 08:57:54"
    avm_git_org              = "lonegunmanb"
    avm_git_repo             = "terraform-yor-tag-test-module"
    avm_yor_trace            = "a0425718-c57d-401c-a7d5-f3d88b2551a4"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))
}
```

To enable tracing tags, set the variable to true:

```hcl
module "example" {
  source               = "{module_source}"
  ...
  tracing_tags_enabled = true
}
```

The `tracing_tags_enabled` is default to `false`.

To customize the prefix for your tracing tags, set the `tracing_tags_prefix` variable value in your Terraform configuration:

```hcl
module "example" {
  source              = "{module_source}"
  ...
  tracing_tags_prefix = "custom_prefix_"
}
```

The actual applied tags would be:

```text
{
  custom_prefix_git_commit           = "3077cc6d0b70e29b6e106b3ab98cee6740c916f6"
  custom_prefix_git_file             = "main.tf"
  custom_prefix_git_last_modified_at = "2023-05-05 08:57:54"
  custom_prefix_git_org              = "lonegunmanb"
  custom_prefix_git_repo             = "terraform-yor-tag-test-module"
  custom_prefix_yor_trace            = "a0425718-c57d-401c-a7d5-f3d88b2551a4"
}
```

## Pre-Commit & Pr-Check & Test

### Configurations

- [Configure Terraform for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)

We assumed that you have setup service principal's credentials in your environment variables like below:

```shell
export ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
export ARM_TENANT_ID="<azure_subscription_tenant_id>"
export ARM_CLIENT_ID="<service_principal_appid>"
export ARM_CLIENT_SECRET="<service_principal_password>"
```

On Windows Powershell:

```shell
$env:ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
$env:ARM_TENANT_ID="<azure_subscription_tenant_id>"
$env:ARM_CLIENT_ID="<service_principal_appid>"
$env:ARM_CLIENT_SECRET="<service_principal_password>"
```

We provide a docker image to run the pre-commit checks and tests for you: `mcr.microsoft.com/azterraform:latest`

To run the pre-commit task, we can run the following command:

```shell
$ docker run --rm -v $(pwd):/src -w /src mcr.microsoft.com/azterraform:latest make pre-commit
```

On Windows Powershell:

```shell
$ docker run --rm -v ${pwd}:/src -w /src mcr.microsoft.com/azterraform:latest make pre-commit
```

In pre-commit task, we will:

1. Run `terraform fmt -recursive` command for your Terraform code.
2. Run `terrafmt fmt -f` command for markdown files and go code files to ensure that the Terraform code embedded in these files are well formatted.
3. Run `go mod tidy` and `go mod vendor` for test folder to ensure that all the dependencies have been synced.
4. Run `gofmt` for all go code files.
5. Run `gofumpt` for all go code files.
6. Run `terraform-docs` on `README.md` file, then run `markdown-table-formatter` to format markdown tables in `README.md`.

Then we can run the pr-check task to check whether our code meets our pipeline's requirement (we strongly recommend you run the following command before you commit):

```shell
$ docker run --rm -v $(pwd):/src -w /src -e TFLINT_CONFIG=.tflint_alt.hcl mcr.microsoft.com/azterraform:latest make pr-check
```

On Windows Powershell:

```shell
$ docker run --rm -v ${pwd}:/src -w /src -e TFLINT_CONFIG=.tflint_alt.hcl mcr.microsoft.com/azterraform:latest make pr-check
```

To run the e2e-test, we can run the following command:

```text
docker run --rm -v $(pwd):/src -w /src -e ARM_SUBSCRIPTION_ID -e ARM_TENANT_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET mcr.microsoft.com/azterraform:latest make e2e-test
```

On Windows Powershell:

```text
docker run --rm -v ${pwd}:/src -w /src -e ARM_SUBSCRIPTION_ID -e ARM_TENANT_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET mcr.microsoft.com/azterraform:latest make e2e-test
```

#### Prerequisites

- [Docker](https://www.docker.com/community-edition#/download)


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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.11.0, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=3.11.0, < 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.custom_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.custom_rules_for](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.predefined_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.predefined_rules_for](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_resource_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_rules"></a> [custom\_rules](#input\_custom\_rules) | Security rules for the network security group using this format name = [name, priority, direction, access, protocol, source\_port\_range, destination\_port\_range, source\_address\_prefix, destination\_address\_prefix, description] | `any` | `[]` | no |
| <a name="input_destination_address_prefix"></a> [destination\_address\_prefix](#input\_destination\_address\_prefix) | Destination address prefix to be applied to all predefined rules. list(string) only allowed one element (CIDR, `*`, source IP range or Tags). Example ["10.0.3.0/24"] or ["VirtualNetwork"] | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_destination_address_prefixes"></a> [destination\_address\_prefixes](#input\_destination\_address\_prefixes) | Destination address prefix to be applied to all predefined rules. Example ["10.0.3.0/32","10.0.3.128/32"] | `list(string)` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Location (Azure Region) for the network security group. | `string` | `""` | no |
| <a name="input_predefined_rules"></a> [predefined\_rules](#input\_predefined\_rules) | Predefined rules | `any` | `[]` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_rules"></a> [rules](#input\_rules) | Standard set of predefined rules | `map(any)` | <pre>{<br>  "ActiveDirectory-AllowADDSWebServices": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "9389",<br>    "AllowADDSWebServices"<br>  ],<br>  "ActiveDirectory-AllowADGCReplication": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "3268",<br>    "AllowADGCReplication"<br>  ],<br>  "ActiveDirectory-AllowADGCReplicationSSL": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "3269",<br>    "AllowADGCReplicationSSL"<br>  ],<br>  "ActiveDirectory-AllowADReplication": [<br>    "Inbound",<br>    "Allow",<br>    "*",<br>    "*",<br>    "389",<br>    "AllowADReplication"<br>  ],<br>  "ActiveDirectory-AllowADReplicationSSL": [<br>    "Inbound",<br>    "Allow",<br>    "*",<br>    "*",<br>    "636",<br>    "AllowADReplicationSSL"<br>  ],<br>  "ActiveDirectory-AllowADReplicationTrust": [<br>    "Inbound",<br>    "Allow",<br>    "*",<br>    "*",<br>    "445",<br>    "AllowADReplicationTrust"<br>  ],<br>  "ActiveDirectory-AllowDFSGroupPolicy": [<br>    "Inbound",<br>    "Allow",<br>    "Udp",<br>    "*",<br>    "138",<br>    "AllowDFSGroupPolicy"<br>  ],<br>  "ActiveDirectory-AllowDNS": [<br>    "Inbound",<br>    "Allow",<br>    "*",<br>    "*",<br>    "53",<br>    "AllowDNS"<br>  ],<br>  "ActiveDirectory-AllowFileReplication": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "5722",<br>    "AllowFileReplication"<br>  ],<br>  "ActiveDirectory-AllowKerberosAuthentication": [<br>    "Inbound",<br>    "Allow",<br>    "*",<br>    "*",<br>    "88",<br>    "AllowKerberosAuthentication"<br>  ],<br>  "ActiveDirectory-AllowNETBIOSAuthentication": [<br>    "Inbound",<br>    "Allow",<br>    "Udp",<br>    "*",<br>    "137",<br>    "AllowNETBIOSAuthentication"<br>  ],<br>  "ActiveDirectory-AllowNETBIOSReplication": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "139",<br>    "AllowNETBIOSReplication"<br>  ],<br>  "ActiveDirectory-AllowPasswordChangeKerberes": [<br>    "Inbound",<br>    "Allow",<br>    "*",<br>    "*",<br>    "464",<br>    "AllowPasswordChangeKerberes"<br>  ],<br>  "ActiveDirectory-AllowRPCReplication": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "135",<br>    "AllowRPCReplication"<br>  ],<br>  "ActiveDirectory-AllowSMTPReplication": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "25",<br>    "AllowSMTPReplication"<br>  ],<br>  "ActiveDirectory-AllowWindowsTime": [<br>    "Inbound",<br>    "Allow",<br>    "Udp",<br>    "*",<br>    "123",<br>    "AllowWindowsTime"<br>  ],<br>  "Cassandra": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "9042",<br>    "Cassandra"<br>  ],<br>  "Cassandra-JMX": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "7199",<br>    "Cassandra-JMX"<br>  ],<br>  "Cassandra-Thrift": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "9160",<br>    "Cassandra-Thrift"<br>  ],<br>  "CouchDB": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "5984",<br>    "CouchDB"<br>  ],<br>  "CouchDB-HTTPS": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "6984",<br>    "CouchDB-HTTPS"<br>  ],<br>  "DNS-TCP": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "53",<br>    "DNS-TCP"<br>  ],<br>  "DNS-UDP": [<br>    "Inbound",<br>    "Allow",<br>    "Udp",<br>    "*",<br>    "53",<br>    "DNS-UDP"<br>  ],<br>  "DynamicPorts": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "49152-65535",<br>    "DynamicPorts"<br>  ],<br>  "ElasticSearch": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "9200-9300",<br>    "ElasticSearch"<br>  ],<br>  "FTP": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "21",<br>    "FTP"<br>  ],<br>  "HTTP": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "80",<br>    "HTTP"<br>  ],<br>  "HTTPS": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "443",<br>    "HTTPS"<br>  ],<br>  "IMAP": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "143",<br>    "IMAP"<br>  ],<br>  "IMAPS": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "993",<br>    "IMAPS"<br>  ],<br>  "Kestrel": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "22133",<br>    "Kestrel"<br>  ],<br>  "LDAP": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "389",<br>    "LDAP"<br>  ],<br>  "MSSQL": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "1433",<br>    "MSSQL"<br>  ],<br>  "Memcached": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "11211",<br>    "Memcached"<br>  ],<br>  "MongoDB": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "27017",<br>    "MongoDB"<br>  ],<br>  "MySQL": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "3306",<br>    "MySQL"<br>  ],<br>  "Neo4J": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "7474",<br>    "Neo4J"<br>  ],<br>  "POP3": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "110",<br>    "POP3"<br>  ],<br>  "POP3S": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "995",<br>    "POP3S"<br>  ],<br>  "PostgreSQL": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "5432",<br>    "PostgreSQL"<br>  ],<br>  "RDP": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "3389",<br>    "RDP"<br>  ],<br>  "RabbitMQ": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "5672",<br>    "RabbitMQ"<br>  ],<br>  "Redis": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "6379",<br>    "Redis"<br>  ],<br>  "Riak": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "8093",<br>    "Riak"<br>  ],<br>  "Riak-JMX": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "8985",<br>    "Riak-JMX"<br>  ],<br>  "SMTP": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "25",<br>    "SMTP"<br>  ],<br>  "SMTPS": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "465",<br>    "SMTPS"<br>  ],<br>  "SSH": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "22",<br>    "SSH"<br>  ],<br>  "WinRM": [<br>    "Inbound",<br>    "Allow",<br>    "Tcp",<br>    "*",<br>    "5986",<br>    "WinRM"<br>  ]<br>}</pre> | no |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | Network security group name | `string` | `"nsg"` | no |
| <a name="input_source_address_prefix"></a> [source\_address\_prefix](#input\_source\_address\_prefix) | Source address prefix to be applied to all predefined rules. list(string) only allowed one element (CIDR, `*`, source IP range or Tags). Example ["10.0.3.0/24"] or ["VirtualNetwork"] | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_source_address_prefixes"></a> [source\_address\_prefixes](#input\_source\_address\_prefixes) | Destination address prefix to be applied to all predefined rules. Example ["10.0.3.0/32","10.0.3.128/32"] | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to associate with your network security group. | `map(string)` | `{}` | no |
| <a name="input_tracing_tags_enabled"></a> [tracing\_tags\_enabled](#input\_tracing\_tags\_enabled) | Whether enable tracing tags that generated by BridgeCrew Yor. | `bool` | `false` | no |
| <a name="input_tracing_tags_prefix"></a> [tracing\_tags\_prefix](#input\_tracing\_tags\_prefix) | Default prefix for generated tracing tags | `string` | `"avm_"` | no |
| <a name="input_use_for_each"></a> [use\_for\_each](#input\_use\_for\_each) | Choose wheter to use 'for\_each' as iteration technic to generate the rules, defaults to false so we will use 'count' for compatibilty with previous module versions, but prefered method is 'for\_each' | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network_security_group_id"></a> [network\_security\_group\_id](#output\_network\_security\_group\_id) | The id of newly created network security group |
| <a name="output_network_security_group_name"></a> [network\_security\_group\_name](#output\_network\_security\_group\_name) | The name of newly created network security group |
<!-- END_TF_DOCS -->
