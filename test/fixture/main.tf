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

module "testPredefinedRuleWithCustom" {
  source                                     = "../../"
  resource_group_name                        = azurerm_resource_group.test.name
  security_group_name                        = "nsg_testPredefinedWithCustom"
  custom_rules                               = var.custom_rules
  predefined_rules                           = var.predefined_rules
  source_application_security_group_ids      = [azurerm_application_security_group.first.id]
  destination_application_security_group_ids = [azurerm_application_security_group.second.id]
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

module "testCustom" {
  source                                     = "../../"
  resource_group_name                        = azurerm_resource_group.test.name
  security_group_name                        = "nsg_testCustom"
  custom_rules                               = var.custom_rules
  source_application_security_group_ids      = [azurerm_application_security_group.first.id]
  destination_application_security_group_ids = [azurerm_application_security_group.second.id]
}
