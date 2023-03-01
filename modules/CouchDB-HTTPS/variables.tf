variable "custom_rules" {
  description = "Custom set of security rules using this format"
  type        = list(any)
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

variable "destination_address_prefix" {
  type    = list(any)
  default = ["*"]

  # Example: ["10.0.3.0/32","10.0.3.128/32"]
}

variable "resource_group_name" {
  default     = "nsg_rg"
  description = "Name of the resource group"
}

variable "security_group_name" {
  description = "Name of the network security group"
  default     = "nsg"
}

variable "source_address_prefix" {
  type    = list(any)
  default = ["*"]

  # Example: ["10.0.3.0/24"]
}

variable "tags" {
  description = "The tags to associate with your network security group."
  type        = map(string)
  default     = {}
}

variable "use_for_each" {
  description = "Choose wheter to use 'for_each' as iteration technic to generate the rules, defaults to false so we will use 'count' for compatibilty with previous module versions, but prefered method is 'for_each'"
  type        = bool
  default     = false
  nullable    = false
}