data "aws_ami" "bastion" {
  owners = ["self"]
  most_recent = true

  filter {
    name = "name"
    values = ["bastion-*"]
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

module "bastion_host" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "${local.name_prefix}-bastion"
  instance_count = 1
  instance_type = "t2.micro"

  ami = data.aws_ami.bastion.id
  key_name = var.aws_key_pair_key_name
  vpc_security_group_ids = [
    aws_security_group.bastion.id,
    aws_security_group.allow_ssh_ingress_from_all.id,
  ]
  subnet_ids = var.public_subnet_ids
  associate_public_ip_address = true
  user_data = filebase64("${path.module}/user_data.yaml")

  tags = {
    Name = "${local.name_prefix}-bastion"
    name = "${local.name_prefix}-bastion"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }
}
