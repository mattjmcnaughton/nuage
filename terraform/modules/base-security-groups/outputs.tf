output "allow_ssh_ingress_from_all_security_group_id" {
  value = aws_security_group.allow_ssh_ingress_from_all.id
}

output "allow_all_egress_to_all_security_group_id" {
  value = aws_security_group.allow_all_egress_to_all.id
}
