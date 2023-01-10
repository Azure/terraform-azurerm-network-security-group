module "test-nsg" {
  source = "../http"

  security_group_name = "web-http"
  resource_group_name = "nsg-http"
  location            = "westus"

  destination_address_prefix = ["10.0.3.0/32"]
}

output "nsg_id" {
  value = module.test-nsg.network_security_group_id
}

output "nsg_name" {
  value = module.test-nsg.network_security_group_name
}
