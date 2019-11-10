resource "aws_security_group" "allow_ssh_ingress_from_all" {
  name = "${var.name_prefix}-allow-ssh-ingress-from-all"
  description = "Security group allowing ssh ingress from all ips"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-allow-ssh-ingress-from-all"
    name = "${var.name_prefix}-allow-ssh-ingress-from-all"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}

resource "aws_security_group" "allow_all_egress_to_all" {
  name = "${var.name_prefix}-allow-all-egress-to-all"
  description = "Security group allowing egress on all ports to all ips"
  vpc_id = var.vpc_id

  ingress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-allow-all-egress-to-all"
    name = "${var.name_prefix}-allow-all-egress-to-all"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}
