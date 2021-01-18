data "aws_ami" "blog" {
  owners = ["self"]
  most_recent = true

  filter {
    name = "name"
    values = ["blog-*"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

module "blog_ec2" {
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name = "${local.name_prefix}-blog"

  # If we ever make the `instance_count` more than 1, we need to update how we
  # specify DNS records.
  instance_count = 1

  iam_instance_profile = aws_iam_instance_profile.blog.name
  ami = data.aws_ami.blog.id
  instance_type = "t3.nano"

  key_name = var.aws_key_pair_key_name
  user_data_base64 = filebase64("${path.module}/user_data.yaml")

  subnet_ids = var.public_subnet_ids
  vpc_security_group_ids = concat([
    aws_security_group.blog.id,
  ], var.extra_host_security_groups)
  associate_public_ip_address = true

  tags = {
    Name = "${local.name_prefix}-blog"
    name = "${local.name_prefix}-blog"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}
