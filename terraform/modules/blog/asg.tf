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

module "blog_asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # TODO: I _think_ we want the launch configuration to be defined separately,
  # and then use the launch configuration name to determine the auto-scaling
  # group name. This dependency will force us to generate a new auto-scaling group
  # when we change the launch configuration (i.e. launch new hosts).
  name = "${local.name_prefix}-blog"
  lc_name = "${local.name_prefix}-blog-lc"

  iam_instance_profile = aws_iam_instance_profile.blog.name
  image_id = data.aws_ami.blog.id
  instance_type = "t3.nano"
  # Use spot instance... I'm comfortable with this machine occassionally going
  # down. .0052 is the per hour price.
  #
  # Just using `spot_price` is sufficient to force usage of a spot instance.
  spot_price = ".0052"

  key_name = var.aws_key_pair_key_name
  user_data = filebase64("${path.module}/user_data.yaml")

  security_groups = concat([
    aws_security_group.blog.id,
  ], var.extra_host_security_groups)
  target_group_arns = concat([
    aws_lb_target_group.blog.arn
  ], var.extra_lb_target_groups)

  vpc_zone_identifier = var.public_subnet_ids

  asg_name = "${local.name_prefix}-blog-asg"
  health_check_type = "EC2"
  min_size = 0
  max_size = 1
  desired_capacity = 1
  wait_for_capacity_timeout = 0
  default_cooldown = 15

  tags_as_map = {
    Name = "${local.name_prefix}-blog"
    name = "${local.name_prefix}-blog"
    environment = var.environment
    Terraform = "true"
    project = "nuage"
  }

  recreate_asg_when_lc_changes = true
}
