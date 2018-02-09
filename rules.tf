variable "rules" {
  description = "Standard set of predefined rules"
  type        = "map"

  # [priority, direction, access, protocol, source_port_range, destination_port_range, description]"
  # The following info are in the submodules: source_address_prefix, destination_address_prefix
  default = {
    # HTTP
    http-80-tcp   = ["Inbound", "Allow", "Tcp", "*", "80", "Allow HTTP"]
    https-443-tcp = ["Inbound", "Allow", "Tcp", "*", "443", "Allow HTTPS"]

    # Active Directory
    ad-389-tcp  = ["Inbound", "Allow", "*", "389", "Allow AD Replication"]
    ad-636-tcp  = ["Inbound", "Allow", "*", "636", "Allow AD Replication SSL"]
    ad-3268-tcp = ["Inbound", "Allow", "Tcp", "3268", "Allow AD GC Replication"]
    ad-3269-tcp = ["Inbound", "Allow", "Tcp", "3269", "Allow AD GC Replication SSL"]
    ad-53-all   = ["Inbound", "Allow", "*", "53", "Allow DNS"]
    ad-88-all   = ["Inbound", "Allow", "*", "88", "Allow Kerberos Authentication"]
    ad-445-all  = ["Inbound", "Allow", "*", "445", "Allow AD Replication Trust"]
    ad-25-tcp   = ["Inbound", "Allow", "Tcp", "25", "Allow SMTP Replication"]
    ad-135-tcp  = ["Inbound", "Allow", "Tcp", "135", "Allow RPC Replication"]
    ad-5722-tcp = ["Inbound", "Allow", "Tcp", "5722", "Allow File Replication"]
    ad-123-udp  = ["Inbound", "Allow", "Udp", "123", "Allow Windows Time"]
    ad-464-all  = ["Inbound", "Allow", "*", "464", "Allow Password Change Kerberes"]
    ad-138-udp  = ["Inbound", "Allow", "Udp", "138", "Allow DFS Group Policy"]
    ad-9389-tcp = ["Inbound", "Allow", "Tcp", "9389", "Allow AD DS Web Services"]
    ad-137-udp  = ["Inbound", "Allow", "Udp", "137", "Allow NETBIOS Authentication"]
    ad-139-tcp  = ["Inbound", "Allow", "Tcp", "139", "Allow NETBIOS Replication"]

    # SSH 
    ssh = ["Inbound", "Allow", "Tcp", "*", "22", "SSH Rules"]
  }
}

variable "rules_group" {
  description = "group of rules for standard applications"
  type        = "map"

  default = {
    # Default security rules for a web application
    webServer = {
      http-80-tcp   = ""
      https-443-tcp = ""
    }

    # Default security rules for Active Directory
    activeDirectory = {
      ad-389-tcp  = ""
      ad-636-tcp  = ""
      ad-3268-tcp = ""
      ad-3269-tcp = ""
      ad-53-all   = ""
      ad-88-all   = ""
      ad-445-all  = ""
      ad-25-tcp   = ""
      ad-135-tcp  = ""
      ad-5722-tcp = ""
      ad-123-udp  = ""
      ad-464-all  = ""
      ad-138-udp  = ""
      ad-9389-tcp = ""
      ad-137-udp  = ""
      ad-139-tcp  = ""
    }
  }
}
