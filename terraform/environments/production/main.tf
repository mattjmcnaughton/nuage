locals {
  environment = "production"
  name_prefix = "p"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.name_prefix}-nuage-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["us-east-1a", "us-east-1b"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
  public_subnet_tags = {
    public = "true"
  }

  tags = {
    Name        = "${local.name_prefix}-nuage-vpc"
    name        = "${local.name_prefix}-nuage-vpc"
    environment = local.environment
    Terraform   = "true"
    project     = "nuage"
  }

  # Changes when upgrading the `vpc` module.
  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_security_group = false
  enable_dns_hostnames          = false
  map_public_ip_on_launch       = true
}

module "base" {
  source = "../../modules/base"

  environment = local.environment
  vpc_id      = module.vpc.vpc_id
}
