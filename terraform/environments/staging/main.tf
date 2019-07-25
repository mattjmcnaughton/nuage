module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "s-nuage-vpc"
  cidr = "10.0.0.0/16"

  azs = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true

  tags = {
    Name = "s-nuage-vpc"
    name = "s-nuage-vpc"
    environment = "staging"
    Terraform = "true"
    project = "nuage"
  }
}
