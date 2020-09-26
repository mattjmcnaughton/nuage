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


resource "aws_security_group" "allow_http_ingress_from_all" {
  name = "${local.name_prefix}-allow-http-ingress-from-all"
  description = "Security group allowing http ingress from all ips"
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-allow-http-ingress-from-all"
    name = "${local.name_prefix}-allow-http-ingress-from-all"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}

resource "aws_security_group" "allow_https_ingress_from_all" {
  name = "${local.name_prefix}-allow-https-ingress-from-all"
  description = "Security group allowing https ingress from all ips"
  vpc_id = var.vpc_id

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-allow-https-ingress-from-all"
    name = "${local.name_prefix}-allow-https-ingress-from-all"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}

resource "aws_security_group" "main_alb" {
  name = "${local.name_prefix}-main-alb"
  description = "Security group attached to the main alb"
  vpc_id = var.vpc_id

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
    Name = "${local.name_prefix}-main-alb"
    name = "${local.name_prefix}-main-alb"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}

resource "aws_security_group" "allow_http_ingress_from_main_alb" {
  name = "${local.name_prefix}-allow-http-ingress-from-main-alb"
  description = "Security group allowing http ingress from main alb"
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [
      aws_security_group.main_alb.id
    ]
  }

  tags = {
    Name = "${local.name_prefix}-allow-http-ingress-from-main-alb"
    name = "${local.name_prefix}-allow-http-ingress-from-main-alb"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}

resource "aws_security_group" "allow_https_ingress_from_main_alb" {
  name = "${local.name_prefix}-allow-https-ingress-from-main-alb"
  description = "Security group allowing https ingress from main alb"
  vpc_id = var.vpc_id

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_groups = [
      aws_security_group.main_alb.id
    ]
  }

  tags = {
    Name = "${local.name_prefix}-allow-https-ingress-from-main-alb"
    name = "${local.name_prefix}-allow-https-ingress-from-main-alb"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}
