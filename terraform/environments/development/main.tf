locals {
  environment = "development"
  name_prefix = "d"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.name_prefix}-nuage-vpc"
  cidr = "10.0.0.0/16"

  azs = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
  public_subnet_tags = {
    public = "true"
  }

  enable_nat_gateway = true

  tags = {
    Name = "${local.name_prefix}-nuage-vpc"
    name = "${local.name_prefix}-nuage-vpc"
    environment = local.environment
    Terraform = "true"
    project = "nuage"
  }
}

module "bastion" {
  source = "../../modules/bastion"

  environment = local.environment

  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnets
  private_subnet_ids = module.vpc.private_subnets
}
