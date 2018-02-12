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

module "testSimple" {
  source              = "../../../modules/http/"
  resource_group_name = "${random_id.randomize.hex}"
  location            = "${var.location}"
  security_group_name = "nsg_testSimple_${random_id.randomize.hex}"
}

module "testSimpleWithCustom" {
  source              = "../../../"
  resource_group_name = "${random_id.randomize.hex}"
  location            = "${var.location}"
  security_group_name = "nsg_testSimpleWithCustom_${random_id.randomize.hex}"
  custom_rules        = "${var.custom_rules}"
  predefined_rules    = "${var.predefined_rules}"
}

module "testCustom" {
  source              = "../../../"
  resource_group_name = "${random_id.randomize.hex}"
  location            = "${var.location}"
  security_group_name = "nsg_testCustom_${random_id.randomize.hex}"
  custom_rules        = "${var.custom_rules}"
}

module "testCustomSourcePort" {
  source              = "../../../"
  resource_group_name = "${random_id.randomize.hex}"
  location            = "${var.location}"
  security_group_name = "nsg_testCustom_${random_id.randomize.hex}"
  custom_rules        = "${var.custom_rules}"
}

module "testCustomDestinationPort" {
  source              = "../../../"
  resource_group_name = "${random_id.randomize.hex}"
  location            = "${var.location}"
  security_group_name = "nsg_testCustomDestinationPort_${random_id.randomize.hex}"
  custom_rules        = "${var.custom_rules}"
}

module "testCustomSourcePortRange1" {
  source              = "../../../"
  resource_group_name = "${random_id.randomize.hex}"
  location            = "${var.location}"
  security_group_name = "nsg_testCustomSourcePortRange1_${random_id.randomize.hex}"
  custom_rules        = "${var.custom_rules}"
}

module "testCustomSourcePortRange2" {
  source              = "../../../"
  resource_group_name = "${random_id.randomize.hex}"
  location            = "${var.location}"
  security_group_name = "nsg_testCustomSourcePortRange2_${random_id.randomize.hex}"
  custom_rules        = "${var.custom_rules}"
}

module "testCustomDestinationPortRange1" {
  source              = "../../../"
  resource_group_name = "${random_id.randomize.hex}"
  location            = "${var.location}"
  security_group_name = "nsg_testCustomDestinationPortRange1_${random_id.randomize.hex}"
  custom_rules        = "${var.custom_rules}"
}

module "testCustomDestinationPortRange2" {
  source              = "../../../"
  resource_group_name = "${random_id.randomize.hex}"
  location            = "${var.location}"
  security_group_name = "nsg_testCustomDestinationPortRange2_${random_id.randomize.hex}"
  custom_rules        = "${var.custom_rules}"
}