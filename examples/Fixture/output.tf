output "network_security_group_id_testPredefinedHTTP" {
  value = module.testPredefinedHTTP.network_security_group_id
}

output "network_security_group_id_testPredefinedAD" {
  value = module.testPredefinedAD.network_security_group_id
}

output "network_security_group_id_testPredefinedWithCustom" {
  value = module.testPredefinedRuleWithCustom.network_security_group_id
}

output "network_security_group_id_testCustom" {
  value = module.testCustom.network_security_group_id
}
