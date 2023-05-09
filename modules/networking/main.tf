data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "us-east-2"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

 
    tags = {
    Terraform    = "true"
    GithubRepo = "toelt/bogus-gitops"
    Environment = "dev"
  } 
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.1"

  cidr = local.vpc_cidr

  manage_default_vpc = true
  default_vpc_name = "bogus-vpc"
  default_vpc_enable_dns_hostnames = true
  default_vpc_enable_dns_support = true
  
  azs             = ["us-east-2a","us-east-2b"]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 1)]
  database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 2)]

  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = true

  manage_default_security_group = true
  manage_default_route_table = true



  default_vpc_tags = local.tags
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "4.0.1"

  create = false
}