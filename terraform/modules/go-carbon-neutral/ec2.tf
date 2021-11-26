data "aws_ami" "go_carbon_neutral" {
  owners = ["self"]
  most_recent = true

  filter {
    name = "name"
    values = ["go-carbon-neutral-*"]
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

module "go_carbon_neutral_ec2" {
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name = "${local.name_prefix}-go-carbon-neutral"

  # If we ever make the `instance_count` more than 1, we need to update how we
  # specify DNS records.
  instance_count = 1

  iam_instance_profile = aws_iam_instance_profile.go_carbon_neutral.name
  ami = data.aws_ami.go_carbon_neutral.id
  instance_type = "t3.nano"

  key_name = var.aws_key_pair_key_name
  user_data_base64 = filebase64("${path.module}/user_data.yaml")

  subnet_ids = var.public_subnet_ids
  vpc_security_group_ids = concat([
    aws_security_group.go_carbon_neutral.id,
  ], var.extra_host_security_groups)
  associate_public_ip_address = true

  tags = {
    Name = "${local.name_prefix}-go-carbon-neutral"
    name = "${local.name_prefix}-go-carbon-neutral"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}
