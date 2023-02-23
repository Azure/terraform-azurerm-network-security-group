module "nsg" {
  source              = "../../"
  resource_group_name = var.resource_group_name
  use_for_each        = var.use_for_each

  security_group_name = var.security_group_name

  predefined_rules = [
    {
      name     = "ActiveDirectory-AllowNETBIOSReplication"
      priority = 501
    },
    {
      name     = "ActiveDirectory-AllowNETBIOSAuthentication"
      priority = 502
    },
    {
      name     = "ActiveDirectory-AllowADDSWebServices"
      priority = 503
    },
    {
      name     = "ActiveDirectory-AllowDFSGroupPolicy"
      priority = 504
    },
    {
      name     = "ActiveDirectory-AllowPasswordChangeKerberes"
      priority = 505
    },
    {
      name     = "ActiveDirectory-AllowWindowsTime"
      priority = 506
    },
    {
      name     = "ActiveDirectory-AllowFileReplication"
      priority = 507
    },
    {
      name     = "ActiveDirectory-AllowRPCReplication"
      priority = 508
    },
    {
      name     = "ActiveDirectory-AllowSMTPReplication"
      priority = 509
    },
    {
      name     = "ActiveDirectory-AllowADReplicationTrust"
      priority = 510
    },
    {
      name     = "ActiveDirectory-AllowKerberosAuthentication"
      priority = 511
    },
    {
      name     = "ActiveDirectory-AllowDNS"
      priority = 512
    },
    {
      name     = "ActiveDirectory-AllowADGCReplicationSSL"
      priority = 513
    },
    {
      name     = "ActiveDirectory-AllowADGCReplication"
      priority = 514
    },
    {
      name     = "ActiveDirectory-AllowADReplicationSSL"
      priority = 515
    },
    {
      name     = "ActiveDirectory-AllowADReplication"
      priority = 516
    },
  ]

  custom_rules               = var.custom_rules
  source_address_prefix      = var.source_address_prefix
  destination_address_prefix = var.destination_address_prefix
  tags                       = var.tags
}
