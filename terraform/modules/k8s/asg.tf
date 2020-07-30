data "aws_ami" "k8s" {
  owners = ["self"]
  most_recent = true

  filter {
    name = "name"
    values = ["k8s-*"]
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

module "k8s_master_asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # TODO: I _think_ we want the launch configuration to be defined separately,
  # and then use the launch configuration name to determine the auto-scaling
  # group name. This dependency will force us to generate a new auto-scaling group
  # when we change the launch configuration (i.e. launch new hosts).
  name = "${local.name_prefix}-k8s-master"
  lc_name = "${local.name_prefix}-k8s-master-lc"

  iam_instance_profile = aws_iam_instance_profile.k8s.name
  image_id = data.aws_ami.k8s.id
  instance_type = "m5.medium"

  key_name = var.aws_key_pair_key_name
  user_data = base64encode(templatefile("${path.module}/master_user_data.yaml"), {
    name_prefix = local.name_prefix
  })

  security_groups = concat([
    aws_security_group.k8s.id,
  ], var.extra_host_security_groups)

  asg_name = "${local.name_prefix}-k8s-master-asg"
  health_check_type = "EC2"
  min_size = 0
  max_size = 1
  desired_capacity = 1
  wait_for_capacity_timeout = 0
  default_cooldown = 15

  tags_as_map = {
    Name = "${local.name_prefix}-k8s-master"
    name = "${local.name_prefix}-k8s-master"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }

  recreate_asg_when_lc_changes = true
}

# When I create the worker, I need some way to specify it should be created
# until after the master is DONE initializing.
