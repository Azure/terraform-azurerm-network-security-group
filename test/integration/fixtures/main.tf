variable "location" {}

variable "custom_rules" {
  type = "map"
}

variable "predefined_rules" {
  type = "map"
}

resource "random_id" "randomize" {
  byte_length = 8
}

module "network-security-group" "testSimple" {
  source              = "../../../modules/http/"
  resource_group_name = "${random_id.randomize.hex}"
  location            = "${var.location}"
  security_group_name = "${concat("nsg_testSimple_",random_id.randomize.hex)}"
}

module "network-security-group" "testSimpleWithCustom" {
  source              = "../../../modules/http/"
  resource_group_name = "${random_id.randomize.hex}"
  location            = "${var.location}"
  security_group_name = "${concat("nsg_testSimpleWithCustom_",random_id.randomize.hex)}"
  custom_rules        = "${var.custom_rules}"
}

module "network-security-group" "testCustom" {
  source              = "../../../"
  resource_group_name = "${random_id.randomize.hex}"
  location            = "${var.location}"
  security_group_name = "${concat("nsg_testCustom_",random_id.randomize.hex)}"
  custom_rules        = "${var.custom_rules}"
}
