# Network Security Group definition
variable "resource_group_name" {
  default     = "nsg_rg"
  description = "Name of the resource group"
}

variable "location" {}

variable "security_group_name" {
  description = "Network security group name"
  default     = "nsg"
}

variable "tags" {
  description = "The tags to associate with your network security group."
  type        = "map"
  default     = {}
}

# Security Rules definition 

# Predefined rules   
variable "predefined_rules" {
  type    = "list"
  default = []
}

# Custom security rules
# [priority, direction, access, protocol, source_port_range, destination_port_range, description]"
# All the fields are required.
variable "custom_rules" {
  description = "Security rules for the network security group using this format name = [priority, direction, access, protocol, source_port_range, destination_port_range, source_address_prefix, destination_address_prefix, description]"
  type        = "list"
  default     = []
}

# source address prefix to be applied to all rules
variable "source_address_prefix" {
  type    = "list"
  default = ["*"]

  # Example ["10.0.3.0/24"] or ["VirtualNetwork"]
}

# Destination address prefix to be applied to all rules
variable "destination_address_prefix" {
  type    = "list"
  default = ["*"]

  # Example ["10.0.3.0/32","10.0.3.128/32"] or ["VirtualNetwork"] 
}
