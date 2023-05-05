data "aws_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "us-east-2"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

 
    tags = {
    ManagedBy    = "Terraform"
    GithubRepo = "toelt/bogus-gitops"
  } 
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.1"

  name = "bogus-vpc"
  cidr = local.vpc_cidr

  azs             = ["us-east-2a","us-east-2b"]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k + 4)]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dhcp_options = true

  # tags = local.tags
}