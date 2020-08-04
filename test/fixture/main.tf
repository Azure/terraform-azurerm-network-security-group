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
}

module "testPredefinedAD" {
  source              = "../../modules/ActiveDirectory/"
  resource_group_name = azurerm_resource_group.test.name
  security_group_name = "nsg_testPredefinedAD"
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
      priority                              = 300
      source_application_security_group_ids = [azurerm_application_security_group.first.id]
    },
    {
      name                                  = "HTTPS"
      priority                              = 510
      source_application_security_group_ids = []
    },
  ]
}



module "testCustom" {
  source              = "../../"
  resource_group_name = azurerm_resource_group.test.name
  security_group_name = "nsg_testCustom"
  custom_rules = [
    {
      name                                       = "myssh"
      priority                                   = "500"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "tcp"
      source_port_range                          = "1234"
      destination_port_range                     = "22"
      description                                = "description-myssh"
      source_application_security_group_ids      = [azurerm_application_security_group.first.id]
      destination_application_security_group_ids = []
    },
    {
      name                                       = "myhttp"
      priority                                   = "200"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "tcp"
      source_port_range                          = "666,4096-4098"
      destination_port_range                     = "8080"
      description                                = "description-http"
      source_application_security_group_ids      = []
      destination_application_security_group_ids = [azurerm_application_security_group.second.id]
    },
  ]
}
