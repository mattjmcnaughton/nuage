resource "aws_lb" "main" {
  name = "${local.name_prefix}-main-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.main_alb.id,
    aws_security_group.allow_http_ingress_from_all.id,
    aws_security_group.allow_https_ingress_from_all.id
  ]

  subnets = var.public_subnet_ids

  tags = {
    Name = "${local.name_prefix}-main-alb"
    name = "${local.name_prefix}-main-alb"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}

resource "aws_lb_target_group" "default" {
  name = "${local.name_prefix}-default"
  port = 443
  protocol = "HTTPS"
  vpc_id = var.vpc_id
}

data "aws_acm_certificate" "mattjmcnaughton_com" {
  domain = "*.mattjmcnaughton.com"
  statuses = ["ISSUED"]
  most_recent = true
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = data.aws_acm_certificate.mattjmcnaughton_com.arn

  # By default, will forward traffic to the default target group.
  # We may also decide to ignore the `default` target group, and instead just
  # return a plain text response.
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.default.arn
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
