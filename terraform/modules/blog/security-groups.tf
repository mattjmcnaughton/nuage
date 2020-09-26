resource "aws_security_group" "blog" {
  name = "${local.name_prefix}-blog"
  description = "Security group attached to the blog instance"
  vpc_id = var.vpc_id

  # We must explicitly specify this egress block... otherwise the blog host
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
    Name = "${local.name_prefix}-blog"
    name = "${local.name_prefix}-blog"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}
