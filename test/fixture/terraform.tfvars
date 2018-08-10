location = "westus"

custom_rules = [
  {
    name                   = "myssh"
    priority               = "101"
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "tcp"
    source_port_range      = "1234"
    destination_port_range = "22"
    description            = "description-myssh"
  },
  {
    name                   = "myhttp"
    priority               = "200"
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "tcp"
    source_port_range      = "666,4096-4098"
    destination_port_range = "8080"
    description            = "description-http"
  },
]

predefined_rules = [
  {
    name              = "HTTP"
    source_port_range = "666,1024-1026"
  },
  {
    name     = "HTTPS"
    priority = "510"
  },
]
