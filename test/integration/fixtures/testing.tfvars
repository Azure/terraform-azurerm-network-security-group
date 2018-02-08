location = "westus"

custom_rules = {
            ssh = ["101", "Inbound", "Allow", "Tcp", "*", "22", "*", "*"]
            http = ["200", "Inbound", "Allow", "Tcp", "*", "8080", "*", "*"]
        }

predefined_rules = { 
    http-80-tcp = ""
    http-443-tcp = ""
}

#rule_groupes = {
#    ActiveDirectory
#    
#}