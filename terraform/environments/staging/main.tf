locals {
  environment = "staging"
  name_prefix = "s"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.name_prefix}-nuage-vpc"
  cidr = "10.0.0.0/16"

  azs = ["us-east-1a", "us-east-1b"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
  public_subnet_tags = {
    public = "true"
  }

  tags = {
    Name = "${local.name_prefix}-nuage-vpc"
    name = "${local.name_prefix}-nuage-vpc"
    environment = local.environment
    Terraform = "true"
    project = "nuage"
  }
}

module "blog" {
  source = "../../modules/blog"

  environment = local.environment

  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnets

  extra_host_security_groups = [
    module.base.aws_security_group_allow_ssh_ingress_from_all_id
  ]
}
