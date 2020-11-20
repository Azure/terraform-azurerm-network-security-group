provider "azurerm" {
  features {}
}

resource "random_id" "randomize" {
  byte_length = 8
}

resource "azurerm_resource_group" "test" {
  name     = "test-resources-${random_id.randomize.hex}"
  location = "West Europe"
}

########################################################
# Using a pre-defined rule for http.  Create a network security group that restricts access to port 80 inbound.  No restrictions on source address/port.
########################################################
module "testPredefinedHTTP" {
  source              = "../../modules/HTTP/"
  resource_group_name = azurerm_resource_group.test.name
  security_group_name = "nsg_testPredefinedHTTP"

  depends_on = [azurerm_resource_group.test]
}

module "testPredefinedAD" {
  source              = "../../modules/ActiveDirectory/"
  resource_group_name = azurerm_resource_group.test.name
  security_group_name = "nsg_testPredefinedAD"

  depends_on = [azurerm_resource_group.test]
}

resource "azurerm_application_security_group" "first" {
  name                = "acctest-first"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
}

resource "azurerm_application_security_group" "second" {
  name                = "acctest-second"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
}

module "testPredefinedRuleWithCustom" {
  source              = "../../"
  resource_group_name = azurerm_resource_group.test.name
  security_group_name = "nsg_testPredefinedWithCustom"
  predefined_rules = [
    {
      name                                  = "HTTP"
      source_application_security_group_ids = [azurerm_application_security_group.first.id]
    },
    {
      name     = "HTTPS"
      priority = 510
    },
  ]

  depends_on = [azurerm_resource_group.test]
}

module "testPredefinedRuleWithPrefix" {
  source                = "../../"
  resource_group_name   = azurerm_resource_group.test.name
  security_group_name   = "nsg_${random_id.randomize.hex}testPredefinedWithPrefix"
  source_address_prefix = ["VirtualNetwork"]
  predefined_rules = [
    {
      name = "HTTP"
    },
    {
      name     = "HTTPS"
      priority = 510
    },
  ]

  depends_on = [azurerm_resource_group.test]
}

module "testPredefinedRuleWithPrefixes" {
  source                  = "../../"
  resource_group_name     = azurerm_resource_group.test.name
  security_group_name     = "nsg_${random_id.randomize.hex}testPredefinedWithPrefixes"
  source_address_prefixes = ["10.151.0.0/24", "10.151.1.0/24"]
  predefined_rules = [
    {
      name = "HTTP"
    },
    {
      name     = "HTTPS"
      priority = 510
    },
  ]

  depends_on = [azurerm_resource_group.test]
}



module "testCustom" {
  source              = "../../"
  resource_group_name = azurerm_resource_group.test.name
  security_group_name = "nsg_testCustom"
  custom_rules = [
    {
      name                                  = "myssh"
      priority                              = 201
      direction                             = "Inbound"
      access                                = "Allow"
      protocol                              = "tcp"
      source_port_range                     = "*"
      destination_port_range                = "22"
      description                           = "description-myssh"
      source_application_security_group_ids = [azurerm_application_security_group.first.id]
    },
    {
      name                                       = "myhttp"
      priority                                   = 200
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "tcp"
      source_port_range                          = "*"
      destination_port_range                     = "8080"
      description                                = "description-http"
      destination_application_security_group_ids = [azurerm_application_security_group.second.id]
    },
  ]

  depends_on = [azurerm_resource_group.test]
}

module "testCustomPrefix" {
  source              = "../../"
  resource_group_name = azurerm_resource_group.test.name
  security_group_name = "nsg_${random_id.randomize.hex}testCustomPrefix"
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
      name                                       = "myhttp"
      priority                                   = 200
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "tcp"
      source_port_range                          = "*"
      destination_port_range                     = "8080"
      source_address_prefixes                    = ["10.151.0.0/24", "10.151.1.0/24"]
      description                                = "description-http"
      destination_application_security_group_ids = [azurerm_application_security_group.second.id]
    },
  ]

  depends_on = [azurerm_resource_group.test]
}

