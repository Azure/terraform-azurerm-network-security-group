resource "azurerm_resource_group" "nsg" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.security_group_name}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.nsg.name}"
  tags                = "${var.tags}"
}

#############################
#   Simple security rules   # 
#############################

resource "azurerm_network_security_rule" "simple_rules" {
  count                       = "${length(var.predefined_rules)}"
  name                        = "${element(keys(var.predefined_rules), count.index)}"
  priority                    = "${lookup(var.predefined_rules, element(keys(var.predefined_rules), count.index), "100" )}"
  direction                   = "${element(var.rules["${element(keys(var.predefined_rules), count.index)}"], 0)}"
  access                      = "${element(var.rules["${element(keys(var.predefined_rules), count.index)}"], 1)}"
  protocol                    = "${element(var.rules["${element(keys(var.predefined_rules), count.index)}"], 2)}"
  source_port_range           = "${element(var.rules["${element(keys(var.predefined_rules), count.index)}"], 3)}"
  destination_port_range      = "${element(var.rules["${element(keys(var.predefined_rules), count.index)}"], 4)}"
  source_address_prefix       = "${join(",", var.source_address_prefix)}" 
  destination_address_prefix  = "${join(",", var.destination_address_prefix)}"
  description                 = "${element(var.rules["${element(keys(var.predefined_rules), count.index)}"], 5)}"
  resource_group_name         = "${azurerm_resource_group.nsg.name}"
  network_security_group_name = "${azurerm_network_security_group.nsg.name}"
}

#############################
#  Detailed security rules  # 
#############################

resource "azurerm_network_security_rule" "advanced_rules" {
  count                       = "${length(var.custom_rules)}"
  name                        = "${element(keys(var.custom_rules), count.index)}"
  priority                    = "${element(var.custom_rules["${element(keys(var.custom_rules), count.index)}"], 0)}"
  direction                   = "${element(var.custom_rules["${element(keys(var.custom_rules), count.index)}"], 1)}"
  access                      = "${element(var.custom_rules["${element(keys(var.custom_rules), count.index)}"], 2)}"
  protocol                    = "${element(var.custom_rules["${element(keys(var.custom_rules), count.index)}"], 3)}"
  source_port_range           = "${element(var.custom_rules["${element(keys(var.custom_rules), count.index)}"], 4)}"
  destination_port_range      = "${element(var.custom_rules["${element(keys(var.custom_rules), count.index)}"], 5)}"
  source_address_prefix       = "${element(var.custom_rules["${element(keys(var.custom_rules), count.index)}"], 6)}" 
  destination_address_prefix  = "${element(var.custom_rules["${element(keys(var.custom_rules), count.index)}"], 7)}"
  description                 = "${element(var.custom_rules["${element(keys(var.custom_rules), count.index)}"], 8)}"
  resource_group_name         = "${azurerm_resource_group.nsg.name}"
  network_security_group_name = "${azurerm_network_security_group.nsg.name}"
}

