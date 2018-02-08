variable "rules" {
  description = "standard set of rules"
  type        = "map"

  # [priority, direction, access, protocol, source_port_range, destination_port_range, description]"
  # The following info are in the submodules: source_address_prefix, destination_address_prefix
  default = {
    # HTTP
    http-80-tcp = ["Inbound", "Allow", "Tcp", "*", "80", "HTTP Rules"]
    http-443-tcp = ["Inbound", "Allow", "Tcp", "*", "443", "HTTPS Rules"]

    # SSH 
    ssh = ["Inbound", "Allow", "Tcp", "*", "22", "SSH Rules"]
  }
}

variable "rules_group" {
  description = "group of rules for standard applications"
  type = "map"

  default = {
    # WebServer 
    webServer = [ "http-80-tcp", "http-443-tcp" ]
  }
}
