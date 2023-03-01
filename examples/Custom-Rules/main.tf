resource "random_string" "postfix" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_resource_group" "nsg_rg" {
  location = var.location
  name     = "${var.resource_group_name}${random_string.postfix.result}"
}

module "nsg" {
  source              = "../../"
  resource_group_name = azurerm_resource_group.nsg_rg.name
  use_for_each        = var.use_for_each

  security_group_name = var.security_group_name

  predefined_rules = []

  custom_rules = [{
    name                         = "myssh"
    priority                     = 101
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    destination_address_prefixes = ["10.151.0.0/24", "10.151.1.0/24"]
    destination_port_range       = "22"
    description                  = "description-myssh"
  }]

  source_address_prefix      = var.source_address_prefix
  destination_address_prefix = var.destination_address_prefix
  tags                       = var.tags
}
