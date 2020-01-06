resource "aws_security_group" "k8s" {
  name = "${local.name_prefix}-k8s"
  description = "Security group attached to the k8s instance"
  vpc_id = var.vpc_id

  # We must explicitly specify this egress block... otherwise the k8s host
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
    Name = "${local.name_prefix}-k8s"
    name = "${local.name_prefix}-k8s"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}

# k8s machines should be able to communicte with each other over 6443.
resource "aws_security_group" "allow_k8s_api_ingress_from_k8s" {
  name = "${local.name_prefix}-allow-k8s-api-ingress-from-k8s"
  description = "Security group allowing k8s api ingress from k8s"
  vpc_id = var.vpc_id

  ingress {
    from_port = 6443
    to_port = 6443
    protocol = "tcp"
    security_groups = [
      aws_security_group.k8s.id
    ]
  }

  tags = {
    Name = "${local.name_prefix}-allow-k8s-api-ingress-from-k8s"
    name = "${local.name_prefix}-allow-k8s-api-ingress-from-k8s"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}
