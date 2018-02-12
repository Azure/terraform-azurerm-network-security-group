output "network_security_group_id_testSimple" {
  value = "${module.testSimple.network_security_group_id}"
}

output "network_security_group_id_testSimpleWithCustom" {
  value = "${module.testSimpleWithCustom.network_security_group_id}"
}

output "network_security_group_id_testCustom" {
  value = "${module.testCustom.network_security_group_id}"
}
