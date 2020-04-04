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
