output "aws_iam_policy_access_mattjmcnaughton_ssl_certs_arn" {
  value = aws_iam_policy.access_mattjmcnaughton_ssl_certs.arn
}

output "aws_security_group_allow_ssh_ingress_from_all_id" {
  value = aws_security_group.allow_ssh_ingress_from_all.id
}

output "aws_security_group_allow_http_ingress_from_main_alb_id" {
  value = aws_security_group.allow_http_ingress_from_main_alb.id
}

output "aws_security_group_allow_https_ingress_from_main_alb_id" {
  value = aws_security_group.allow_https_ingress_from_main_alb.id
}

output "aws_lb_main_arn" {
  value = aws_lb.main.arn
}

output "aws_lb_main_dns_name" {
  value = aws_lb.main.dns_name
}

output "aws_lb_main_zone_id" {
  value = aws_lb.main.zone_id
}

output "aws_lb_listener_main_https_arn" {
  value = aws_lb_listener.https.arn
}

output "aws_lb_target_group_default_arn" {
  value = aws_lb_target_group.default.arn
}
