data "azurerm_resource_group" "nsg" {
  name = var.resource_group_name
}

resource "azurerm_network_security_group" "nsg" {
  location            = var.location != "" ? var.location : data.azurerm_resource_group.nsg.location
  name                = var.security_group_name
  resource_group_name = data.azurerm_resource_group.nsg.name
  tags                = var.tags
}

#############################
#   Simple security rules   #
#############################

resource "azurerm_network_security_rule" "predefined_rules" {
  count = length(var.predefined_rules)

  access                                     = element(var.rules[lookup(var.predefined_rules[count.index], "name")], 1)
  direction                                  = element(var.rules[lookup(var.predefined_rules[count.index], "name")], 0)
  name                                       = lookup(var.predefined_rules[count.index], "name")
  network_security_group_name                = azurerm_network_security_group.nsg.name
  priority                                   = lookup(var.predefined_rules[count.index], "priority", 4096 - length(var.predefined_rules) + count.index)
  protocol                                   = element(var.rules[lookup(var.predefined_rules[count.index], "name")], 2)
  resource_group_name                        = data.azurerm_resource_group.nsg.name
  description                                = element(var.rules[lookup(var.predefined_rules[count.index], "name")], 5)
  destination_address_prefix                 = lookup(var.predefined_rules[count.index], "destination_application_security_group_ids", null) == null && var.destination_address_prefixes == null ? join(",", var.destination_address_prefix) : null
  destination_address_prefixes               = lookup(var.predefined_rules[count.index], "destination_application_security_group_ids", null) == null ? var.destination_address_prefixes : null
  destination_application_security_group_ids = lookup(var.predefined_rules[count.index], "destination_application_security_group_ids", null)
  destination_port_range                     = element(var.rules[lookup(var.predefined_rules[count.index], "name")], 4)
  source_address_prefix                      = lookup(var.predefined_rules[count.index], "source_application_security_group_ids", null) == null && var.source_address_prefixes == null ? join(",", var.source_address_prefix) : null
  source_address_prefixes                    = lookup(var.predefined_rules[count.index], "source_application_security_group_ids", null) == null ? var.source_address_prefixes : null
  source_application_security_group_ids      = lookup(var.predefined_rules[count.index], "source_application_security_group_ids", null)
  source_port_range                          = lookup(var.predefined_rules[count.index], "source_port_range", "*") == "*" ? "*" : null
  source_port_ranges                         = lookup(var.predefined_rules[count.index], "source_port_range", "*") == "*" ? null : split(",", var.predefined_rules[count.index].source_port_range)
}

#############################
#  Detailed security rules  #
#############################

resource "azurerm_network_security_rule" "custom_rules" {
  count = length(var.custom_rules)

  access                                     = lookup(var.custom_rules[count.index], "access", "Allow")
  direction                                  = lookup(var.custom_rules[count.index], "direction", "Inbound")
  name                                       = lookup(var.custom_rules[count.index], "name", "default_rule_name")
  network_security_group_name                = azurerm_network_security_group.nsg.name
  priority                                   = lookup(var.custom_rules[count.index], "priority")
  protocol                                   = lookup(var.custom_rules[count.index], "protocol", "*")
  resource_group_name                        = data.azurerm_resource_group.nsg.name
  description                                = lookup(var.custom_rules[count.index], "description", "Security rule for ${lookup(var.custom_rules[count.index], "name", "default_rule_name")}")
  destination_address_prefix                 = lookup(var.custom_rules[count.index], "destination_application_security_group_ids", null) == null && lookup(var.custom_rules[count.index], "destination_address_prefixes", null) == null ? lookup(var.custom_rules[count.index], "destination_address_prefix", "*") : null
  destination_address_prefixes               = lookup(var.custom_rules[count.index], "destination_application_security_group_ids", null) == null ? lookup(var.custom_rules[count.index], "destination_address_prefixes", null) : null
  destination_application_security_group_ids = lookup(var.custom_rules[count.index], "destination_application_security_group_ids", null)
  destination_port_ranges                    = split(",", replace(lookup(var.custom_rules[count.index], "destination_port_range", "*"), "*", "0-65535"))
  source_address_prefix                      = lookup(var.custom_rules[count.index], "source_application_security_group_ids", null) == null && lookup(var.custom_rules[count.index], "source_address_prefixes", null) == null ? lookup(var.custom_rules[count.index], "source_address_prefix", "*") : null
  source_address_prefixes                    = lookup(var.custom_rules[count.index], "source_application_security_group_ids", null) == null ? lookup(var.custom_rules[count.index], "source_address_prefixes", null) : null
  source_application_security_group_ids      = lookup(var.custom_rules[count.index], "source_application_security_group_ids", null)
  source_port_range                          = lookup(var.custom_rules[count.index], "source_port_range", "*") == "*" ? "*" : null
  source_port_ranges                         = lookup(var.custom_rules[count.index], "source_port_range", "*") == "*" ? null : split(",", var.custom_rules[count.index].source_port_range)
}