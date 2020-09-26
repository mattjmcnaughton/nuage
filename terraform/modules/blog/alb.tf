resource "aws_lb_target_group" "blog" {
  name = "${local.name_prefix}-blog"
  port = 443
  protocol = "HTTPS"
  vpc_id = var.vpc_id
}

resource "aws_lb_listener_rule" "blog" {
  listener_arn = var.main_aws_lb_listener_https_arn
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.blog.arn
  }

  condition {
    host_header {
      values = concat([
        "${local.name_prefix}-blog.mattjmcnaughton.com"
      ], var.additional_alias_records_for_lb)
    }
  }
}
