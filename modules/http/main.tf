module "nsg" {
  source              = "../../"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  security_group_name = "${var.security_group_name}"

  predefined_rules = {
    http-80-tcp = "120"
    ssh         = "300"
  }

  source_address_prefix      = "${var.source_address_prefix}"
  destination_address_prefix = "${var.destination_address_prefix}"
  tags                       = "${var.tags}"
}
