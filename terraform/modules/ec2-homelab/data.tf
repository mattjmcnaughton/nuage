# Get the latest Ubuntu 24.04 AMI
data "aws_ssm_parameter" "ubuntu_2404_ami" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  # Filter for public subnets (those without a route to an Internet Gateway)
  # Note: This approach assumes you're using the common tag for private subnets
  filter {
    name   = "tag:public"
    values = ["true"]
  }
}
