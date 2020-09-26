locals {
  environment = "development"
  name_prefix = "d"
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

module "base" {
  source = "../../modules/base"

  environment = local.environment
  public_subnet_ids = module.vpc.public_subnets
  vpc_id = module.vpc.vpc_id
}

module "blog" {
  source = "../../modules/blog"

  environment = local.environment

  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnets

  extra_host_iam_policy = [
    module.base.aws_iam_policy_access_mattjmcnaughton_ssl_certs_arn
  ]

  extra_host_security_groups = [
    module.base.aws_security_group_allow_ssh_ingress_from_all_id,
    module.base.aws_security_group_allow_http_ingress_from_main_alb_id,
    module.base.aws_security_group_allow_https_ingress_from_main_alb_id
  ]

  main_aws_lb_dns_name = module.base.aws_lb_main_dns_name
  main_aws_lb_zone_id = module.base.aws_lb_main_zone_id
  main_aws_lb_listener_https_arn = module.base.aws_lb_listener_main_https_arn
  extra_lb_target_groups = [
    module.base.aws_lb_target_group_default_arn
  ]
}

module "vidzou" {
  source = "../../modules/vidzou"

  environment = local.environment

  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnets

  extra_host_iam_policy = [
    module.base.aws_iam_policy_access_mattjmcnaughton_ssl_certs_arn
  ]

  extra_host_security_groups = [
    module.base.aws_security_group_allow_ssh_ingress_from_all_id,
    module.base.aws_security_group_allow_http_ingress_from_main_alb_id,
    module.base.aws_security_group_allow_https_ingress_from_main_alb_id
  ]

  main_aws_lb_dns_name = module.base.aws_lb_main_dns_name
  main_aws_lb_zone_id = module.base.aws_lb_main_zone_id
  main_aws_lb_listener_https_arn = module.base.aws_lb_listener_main_https_arn
}
