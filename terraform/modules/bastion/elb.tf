module "bastion_elb" {
  source = "terraform-aws-modules/elb/aws"

  name = "${local.name_prefix}-bastion-elb"

  security_groups = [
    aws_security_group.bastion_elb.id,
    aws_security_group.allow_ssh_ingress_from_all.id,
  ]
  subnets = var.public_subnet_ids
  internal = false

  listener = [
    {
      instance_port = "22"
      instance_protocol = "TCP"
      lb_port = "22"
      lb_protocol = "TCP"
    }
  ]

  health_check = {
    target = "TCP:22"
    interval = 30
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
  }

  tags = {
    Name = "${local.name_prefix}-bastion-elb"
    name = "${local.name_prefix}-bastion-elb"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}
