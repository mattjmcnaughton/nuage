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

module "bastion_asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  name = "${local.name_prefix}-bastion"
  lc_name = "${local.name_prefix}-bastion-lc"

  image_id = data.aws_ami.bastion.id
  instance_type = "t3.nano"
  # Use spot instance... I'm comfortable with this machine occassionally going
  # down. .0052 is the per hour price.
  #
  # Just using `spot_price` is sufficient to force usage of a spot instance.
  spot_price = ".0052"

  key_name = var.aws_key_pair_key_name
  user_data = filebase64("${path.module}/user_data.yaml")

  security_groups = [
    aws_security_group.bastion.id,
    aws_security_group.allow_ssh_ingress_from_bastion_elb.id,
  ]
  load_balancers = [module.bastion_elb.this_elb_id]

  vpc_zone_identifier = var.private_subnet_ids

  asg_name = "${local.name_prefix}-bastion-asg"
  health_check_type = "EC2"
  min_size = 0
  max_size = 1
  desired_capacity = 1
  wait_for_capacity_timeout = 0
  default_cooldown = 15

  tags_as_map = {
    Name = "${local.name_prefix}-bastion"
    name = "${local.name_prefix}-bastion"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }

  recreate_asg_when_lc_changes = true
}
