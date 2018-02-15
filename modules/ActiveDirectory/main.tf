module "nsg" {
  source              = "../../"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  security_group_name = "${var.security_group_name}"

  predefined_rules = [
    {
      name = "ActiveDirectory-AllowNETBIOSReplication"
    },
    {
      name = "ActiveDirectory-AllowNETBIOSAuthentication"
    },
    {
      name = "ActiveDirectory-AllowADDSWebServices"
    },
    {
      name = "ActiveDirectory-AllowDFSGroupPolicy"
    },
    {
      name = "ActiveDirectory-AllowPasswordChangeKerberes"
    },
    {
      name = "ActiveDirectory-AllowWindowsTime"
    },
    {
      name = "ActiveDirectory-AllowFileReplication"
    },
    {
      name = "ActiveDirectory-AllowRPCReplication"
    },
    {
      name = "ActiveDirectory-AllowSMTPReplication"
    },
    {
      name = "ActiveDirectory-AllowADReplicationTrust"
    },
    {
      name = "ActiveDirectory-AllowKerberosAuthentication"
    },
    {
      name = "ActiveDirectory-AllowDNS"
    },
    {
      name = "ActiveDirectory-AllowADGCReplicationSSL"
    },
    {
      name = "ActiveDirectory-AllowADGCReplication"
    },
    {
      name = "ActiveDirectory-AllowADReplicationSSL"
    },
    {
      name = "ActiveDirectory-AllowADReplication"
    },
  ]

  custom_rules               = "${var.custom_rules}"
  source_address_prefix      = "${var.source_address_prefix}"
  destination_address_prefix = "${var.destination_address_prefix}"
  tags                       = "${var.tags}"
}
