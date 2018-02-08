variable "location" {}

variable "custom_rules" {
  type = "map"
}

variable "predefined_rules" {
  type = "map"
}

module "network-security-group" {
  source              = "../../../"
  resource_group_name = "nsg"
  location            = "${var.location}"
  security_group_name = "nsg"
  predefined_rules    = "${var.predefined_rules}"
  custom_rules        = "${var.custom_rules}"
}
