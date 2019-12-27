module "blog_elb" {
  source = "terraform-aws-modules/elb/aws"

  name = "${local.name_prefix}-blog-elb"

  security_groups = [
    aws_security_group.blog_elb.id,
    aws_security_group.allow_http_ingress_from_all.id,
    aws_security_group.allow_https_ingress_from_all.id,
  ]
  subnets = var.public_subnet_ids
  internal = false

  listener = [
    {
      instance_port = "80"
      instance_protocol = "TCP"
      lb_port = "80"
      lb_protocol = "TCP"
    },
    {
      instance_port = "443"
      instance_protocol = "TCP"
      lb_port = "443"
      lb_protocol = "TCP"
    }
  ]

  # AFAIK, the ELB doesn't actually perform ssl validation as part of the health
  # check.
  health_check = {
    target = "HTTPS:443/"
    interval = 30
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
  }

  tags = {
    Name = "${local.name_prefix}-blog-elb"
    name = "${local.name_prefix}-blog-elb"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}
