module "nsg" {
  source              = "../../"
  resource_group_name = var.resource_group_name
  use_for_each        = var.use_for_each

  security_group_name = var.security_group_name

  predefined_rules = [
    {
      name     = "PostgreSQL"
      priority = 501
    },
  ]

  custom_rules               = var.custom_rules
  source_address_prefix      = var.source_address_prefix
  destination_address_prefix = var.destination_address_prefix
  tags                       = var.tags
}
