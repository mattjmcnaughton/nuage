output "aws_iam_policy_access_mattjmcnaughton_ssl_certs_arn" {
  value = aws_iam_policy.access_mattjmcnaughton_ssl_certs.arn
}

output "aws_iam_policy_access_go_carbon_neutral_ssl_certs_arn" {
  value = aws_iam_policy.access_go_carbon_neutral_ssl_certs.arn
}

output "aws_security_group_allow_ssh_ingress_from_all_id" {
  value = aws_security_group.allow_ssh_ingress_from_all.id
}

output "aws_security_group_allow_http_ingress_from_all_id" {
  value = aws_security_group.allow_http_ingress_from_all.id
}

output "aws_security_group_allow_https_ingress_from_all_id" {
  value = aws_security_group.allow_https_ingress_from_all.id
}
