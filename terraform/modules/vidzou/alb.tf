resource "aws_lb_target_group" "vidzou" {
  name = "${local.name_prefix}-vidzou"
  port = 443
  protocol = "HTTPS"
  vpc_id = var.vpc_id
}

resource "aws_lb_listener_rule" "vidzou" {
  listener_arn = var.main_aws_lb_listener_https_arn
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.vidzou.arn
  }

  condition {
    host_header {
      values = concat([
        "${local.name_prefix}-vidzou.mattjmcnaughton.com"
      ], var.additional_alias_records_for_lb)
    }
  }
}
