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

module "ai" {
  source = "../../modules/ec2-homelab"

  vpc_id      = module.vpc.vpc_id
  alert_email = "auto+aws@mattjmcnaughton.com"

  # Optional parameters
  instance_name     = "ai"
  username          = "mattjmcnaughton"
  max_budget        = 20 # $20 per month
  max_runtime_hours = 4  # 4 hours

  root_volume_size        = 25
  data_volume_size        = 50
  data_volume_mount_point = "/encrypted_fs"

  secrets_manager_tailscale_auth_key_name = "homelab/tailscale/ai"

  instance_type   = "g4dn.xlarge"
  is_gpu_instance = true # Install GPU drivers and tools

  tags = {
    environment  = "prod"
    status       = "experimental"
    machineclass = "pet"
  }
}
