resource "aws_security_group" "allow_ssh_ingress_from_all" {
  name = "${local.name_prefix}-allow-ssh-ingress-from-all"
  description = "Security group allowing ssh ingress from all ips"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-allow-ssh-ingress-from-all"
    name = "${local.name_prefix}-allow-ssh-ingress-from-all"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}

resource "aws_security_group" "bastion_elb" {
  name = "${local.name_prefix}-bastion-elb"
  description = "Security group attached to the bastion elb"
  vpc_id = var.vpc_id

  # We must explicitly specify this egress block... otherwise the bastion host
  # can't initiate communication with any other hosts.
  #
  # Long term, I'm not sure whether we want to specify this egress block for
  # every one-to-one mapping between security group and host, or if we want to
  # specify one `allow-all-egress-from-egress` which we reuse everywhere.
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-bastion-elb"
    name = "${local.name_prefix}-bastion-elb"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}

resource "aws_security_group" "bastion" {
  name = "${local.name_prefix}-bastion"
  description = "Security group attached to the bastion instance"
  vpc_id = var.vpc_id

  # We must explicitly specify this egress block... otherwise the bastion host
  # can't initiate communication with any other hosts.
  #
  # Long term, I'm not sure whether we want to specify this egress block for
  # every one-to-one mapping between security group and host, or if we want to
  # specify one `allow-all-egress-from-egress` which we reuse everywhere.
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-bastion"
    name = "${local.name_prefix}-bastion"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}

resource "aws_security_group" "allow_ssh_ingress_from_bastion_elb" {
  name = "${local.name_prefix}-allow-ssh-ingress-from-bastion-elb"
  description = "Security group allowing ssh ingress from bastion elb"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [
      aws_security_group.bastion_elb.id
    ]
  }

  tags = {
    Name = "${local.name_prefix}-allow-ssh-ingress-from-bastion-elb"
    name = "${local.name_prefix}-allow-ssh-ingress-from-bastion-elb"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}

resource "aws_security_group" "allow_ssh_ingress_from_bastion" {
  name = "${local.name_prefix}-allow-ssh-ingress-from-bastion"
  description = "Security group allowing ssh ingress from bastion"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [
      aws_security_group.bastion.id
    ]
  }

  tags = {
    Name = "${local.name_prefix}-allow-ssh-ingress-from-bastion"
    name = "${local.name_prefix}-allow-ssh-ingress-from-bastion"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}
