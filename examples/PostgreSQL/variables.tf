variable "custom_rules" {
  type        = list(any)
  default     = []
  description = "Custom set of security rules using this format"
}

variable "destination_address_prefix" {
  type    = list(any)
  default = ["*"]
}

variable "location" {
  type    = string
  default = "westus"
}

variable "resource_group_name" {
  default     = "nsg_rg"
  description = "Name of the resource group"
}

variable "security_group_name" {
  default     = "nsg"
  description = "Name of the network security group"
}

variable "source_address_prefix" {
  type    = list(any)
  default = ["*"]
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "The tags to associate with your network security group."
}

variable "use_for_each" {
  type        = bool
  default     = false
  description = "Choose wheter to use 'for_each' as iteration technic to generate the rules, defaults to false so we will use 'count' for compatibilty with previous module versions, but prefered method is 'for_each'"
  nullable    = false
}
