# Network security group configuration
variable "resource_group_name" {
  default     = "nsg_rg"
  description = "Name of the resource group"
}

variable "security_group_name" {
  description = "Name of the network security group"
  default     = "nsg"
}

variable "location" {
  description = "location of the nsg and associated resource group"
}

variable "tags" {
  description = "The tags to associate with your network security group."
  type        = "map"
  default     = {}
}

variable "custom_rules" {
  description = "Custom set of security rules using this format"
  type        = "list"
  default     = []

  # Example:
  # custom_rules = [{
  # name                   = "myssh"
  # priority               = "101"
  # direction              = "Inbound"
  # access                 = "Allow"
  # protocol               = "tcp"
  # source_port_range      = "1234"
  # destination_port_range = "22"
  # description            = "description-myssh"
  #}]
}

# Security rules configuration 
variable "source_address_prefix" {
  type    = "list"
  default = ["*"]

  # Example: ["10.0.3.0/24"]
}

variable "destination_address_prefix" {
  type    = "list"
  default = ["*"]

  # Example: ["10.0.3.0/32","10.0.3.128/32"]
}
