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

module "blog" {
  source = "../../modules/blog"

  environment = local.environment

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnets

  extra_host_iam_policy = [
    module.base.aws_iam_policy_access_mattjmcnaughton_ssl_certs_arn
  ]

  extra_host_security_groups = [
    module.base.aws_security_group_allow_ssh_ingress_from_all_id,
    module.base.aws_security_group_allow_http_ingress_from_all_id,
    module.base.aws_security_group_allow_https_ingress_from_all_id
  ]

  additional_alias_records = [
    "mattjmcnaughton.com",
    "blog.mattjmcnaughton.com",
    "www.mattjmcnaughton.com",
  ]
}

data "aws_route53_zone" "public" {
  name = "mattjmcnaughton.com."
}

module "cloudfront_blog" {
  source = "../../modules/cloudfront-blog"

  environment = local.environment

  route53_zone_id = data.aws_route53_zone.public.zone_id
  domain_name     = "archive.mattjmcnaughton.com"
}

# TODO: Need to add the Route53 record for the new blog on `sr.ht`.
