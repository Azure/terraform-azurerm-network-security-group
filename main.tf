data "azurerm_resource_group" "nsg" {
  name = var.resource_group_name
}

resource "azurerm_network_security_group" "nsg" {
  location            = var.location != "" ? var.location : data.azurerm_resource_group.nsg.location
  name                = var.security_group_name
  resource_group_name = data.azurerm_resource_group.nsg.name
  tags = merge(var.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_git_commit           = "fd9037e4f7a3784083665fdb6c781afd2c3f5744"
    avm_git_file             = "main.tf"
    avm_git_last_modified_at = "2023-01-20 10:47:52"
    avm_git_org              = "Azure"
    avm_git_repo             = "terraform-azurerm-network-security-group"
    avm_yor_trace            = "7e410e5c-5ed9-4e8b-8d5e-8d8da29c402c"
    } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/), (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_yor_name = "nsg"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))
}

#############################
#   Simple security rules   #
#############################

resource "azurerm_network_security_rule" "predefined_rules" {
  count = var.use_for_each ? 0 : length(var.predefined_rules)

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
  source_port_ranges                         = lookup(var.predefined_rules[count.index], "source_port_range", "*") == "*" ? null : [for p in split(",", var.predefined_rules[count.index].source_port_range) : trimspace(p)]
}

resource "azurerm_network_security_rule" "predefined_rules_for" {
  for_each = { for value in var.predefined_rules : value.name => value if var.use_for_each }

  access                                     = element(var.rules[lookup(each.value, "name")], 1)
  direction                                  = element(var.rules[lookup(each.value, "name")], 0)
  name                                       = lookup(each.value, "name")
  network_security_group_name                = azurerm_network_security_group.nsg.name
  priority                                   = each.value.priority
  protocol                                   = element(var.rules[lookup(each.value, "name")], 2)
  resource_group_name                        = data.azurerm_resource_group.nsg.name
  description                                = element(var.rules[lookup(each.value, "name")], 5)
  destination_address_prefix                 = lookup(each.value, "destination_application_security_group_ids", null) == null && var.destination_address_prefixes == null ? join(",", var.destination_address_prefix) : null
  destination_address_prefixes               = lookup(each.value, "destination_application_security_group_ids", null) == null ? var.destination_address_prefixes : null
  destination_application_security_group_ids = lookup(each.value, "destination_application_security_group_ids", null)
  destination_port_range                     = element(var.rules[lookup(each.value, "name")], 4)
  source_address_prefix                      = lookup(each.value, "source_application_security_group_ids", null) == null && var.source_address_prefixes == null ? join(",", var.source_address_prefix) : null
  source_address_prefixes                    = lookup(each.value, "source_application_security_group_ids", null) == null ? var.source_address_prefixes : null
  source_application_security_group_ids      = lookup(each.value, "source_application_security_group_ids", null)
  source_port_range                          = lookup(each.value, "source_port_range", "*") == "*" ? "*" : null
  source_port_ranges                         = lookup(each.value, "source_port_range", "*") == "*" ? null : [for r in split(",", each.value.source_port_range) : trimspace(r)]

  lifecycle {
    precondition {
      condition     = try(each.value.priority >= 100 && each.value.priority <= 4096, false)
      error_message = "Precondition failed: 'predefined_rules.priority' must be provided and configured between 100 and 4096 for predefined rules if 'var.use_for_each' is set to true."
    }
  }
}

#############################
#  Detailed security rules  #
#############################

resource "azurerm_network_security_rule" "custom_rules" {
  count = var.use_for_each ? 0 : length(var.custom_rules)

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
  source_port_ranges                         = lookup(var.custom_rules[count.index], "source_port_range", "*") == "*" ? null : [for r in split(",", var.custom_rules[count.index].source_port_range) : trimspace(r)]

  lifecycle {
    precondition {
      condition     = try(var.custom_rules[count.index].priority >= 100 && var.custom_rules[count.index].priority <= 4096, false)
      error_message = "Precondition failed: 'predefined_rules.priority' must be provided and configured between 100 and 4096 for custom rules."
    }
  }
}

resource "azurerm_network_security_rule" "custom_rules_for" {
  for_each = { for value in var.custom_rules : value.name => value if var.use_for_each }

  access                                     = lookup(each.value, "access", "Allow")
  direction                                  = lookup(each.value, "direction", "Inbound")
  name                                       = lookup(each.value, "name", "default_rule_name")
  network_security_group_name                = azurerm_network_security_group.nsg.name
  priority                                   = each.value.priority
  protocol                                   = lookup(each.value, "protocol", "*")
  resource_group_name                        = data.azurerm_resource_group.nsg.name
  description                                = lookup(each.value, "description", "Security rule for ${lookup(each.value, "name", "default_rule_name")}")
  destination_address_prefix                 = lookup(each.value, "destination_application_security_group_ids", null) == null && lookup(each.value, "destination_address_prefixes", null) == null ? lookup(each.value, "destination_address_prefix", "*") : null
  destination_address_prefixes               = lookup(each.value, "destination_application_security_group_ids", null) == null ? lookup(each.value, "destination_address_prefixes", null) : null
  destination_application_security_group_ids = lookup(each.value, "destination_application_security_group_ids", null)
  destination_port_ranges                    = split(",", replace(lookup(each.value, "destination_port_range", "*"), "*", "0-65535"))
  source_address_prefix                      = lookup(each.value, "source_application_security_group_ids", null) == null && lookup(each.value, "source_address_prefixes", null) == null ? lookup(each.value, "source_address_prefix", "*") : null
  source_address_prefixes                    = lookup(each.value, "source_application_security_group_ids", null) == null ? lookup(each.value, "source_address_prefixes", null) : null
  source_application_security_group_ids      = lookup(each.value, "source_application_security_group_ids", null)
  source_port_range                          = lookup(each.value, "source_port_range", "*") == "*" ? "*" : null
  source_port_ranges                         = lookup(each.value, "source_port_range", "*") == "*" ? null : [for r in split(",", each.value.source_port_range) : trimspace(r)]

  lifecycle {
    precondition {
      condition     = try(each.value.priority >= 100 && each.value.priority <= 4096, false)
      error_message = "Precondition failed: 'predefined_rules.priority' must be provided and configured between 100 and 4096 for custom rules."
    }
  }
}