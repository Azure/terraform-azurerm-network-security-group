resource "random_id" "randomize" {
  byte_length = 8
}

########################################################
# Using a pre-defined rule for http.  Create a network security group that restricts access to port 80 inbound.  No restrictions on source address/port.
########################################################
module "testPredefinedHTTP" {
  source              = "../../modules/HTTP/"
  resource_group_name = "${random_id.randomize.hex}"
  location            = "${var.location}"
  security_group_name = "nsg_testPredefinedHTTP"
}

module "testPredefinedAD" {
  source              = "../../modules/ActiveDirectory/"
  resource_group_name = "${random_id.randomize.hex}"
  location            = "${var.location}"
  security_group_name = "nsg_testPredefinedAD"
}

module "testPredefinedRuleWithCustom" {
  source              = "../../"
  resource_group_name = "${random_id.randomize.hex}"
  location            = "${var.location}"
  security_group_name = "nsg_testPredefinedWithCustom"
  custom_rules        = "${var.custom_rules}"
  predefined_rules    = "${var.predefined_rules}"
}

module "testCustom" {
  source              = "../../"
  resource_group_name = "${random_id.randomize.hex}"
  location            = "${var.location}"
  security_group_name = "nsg_testCustom"
  custom_rules        = "${var.custom_rules}"
}
