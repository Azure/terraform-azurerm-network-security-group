output "network_security_group_id" {
  description = "The id of newly created network security group"
  value       = azurerm_network_security_group.nsg.id
}

output "network_security_group_name" {
  description = "The name of newly created network security group"
  value       = azurerm_network_security_group.nsg.name
}