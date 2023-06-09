//TODO Add Terraform lifecycle constraints to resources created and need locking (elastic IP, NAT, IGW ...)
# lifecycle {
#   prevent_destroy = true
# }

# data "aws_availability_zones" "available" {
#   state = "available"
# }

# data "aws_security_group" "default" {
#   name   = "default"
#   vpc_id = module.vpc.vpc_id
# }

# locals {
#   name   = "ex_${local.tags.Project}"
#   # "ex_${basename(path.cwd)}"
#   region = "us-east-1"

#   vpc_cidr = "10.0.0.0/16"
#   azs      = slice(data.aws_availability_zones.available.names, 0, 2)

 
#     tags = {
#     Project      = "bogus_gitops"
#     Terraform    = "true"
#     GithubRepo = "toelt/bogus-gitops"
#     Environment = "dev"
#   } 
# }

# resource "aws_security_group" "vpc_tls" {
#   name_prefix = "${local.name}-vpc_tls"
#   description = "Allow TLS inbound traffic"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     description = "TLS from VPC"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = [module.vpc.vpc_cidr_block]
#   }

#   tags = local.tags
# }

# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "4.0.1"

#   cidr = local.vpc_cidr

#   name = "local.name"
#   # "ex_${basename(path.cwd)}"

#   manage_default_vpc = false
#   # default_vpc_name = "ex_${basename(path.cwd)}"
#   # default_vpc_enable_dns_hostnames = true
#   # default_vpc_enable_dns_support = true
  
#   azs             = ["us-east-1a","us-east-1b"]

#   private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
#   # private_subnet_names = []
#   private_subnet_suffix = "_subnet_private"

#   public_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 2)]
#   # public_subnet_names = []
#   public_subnet_suffix = "_subnet_public"

#   database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]
#   # database_subnet_names = []
#   database_subnet_suffix = "_subnet_db"
#   database_subnet_group_name = "bogus_dev_db_subnet_group"

#   enable_nat_gateway = true
#   single_nat_gateway = true

#   create_database_subnet_group           = false
#   create_database_subnet_route_table     = false
#   create_database_internet_gateway_route = false

#   manage_default_security_group = false
#   manage_default_route_table = false

#   # default_vpc_tags = local.tags
# }

# module "vpc_endpoints" {
#   source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
#   version = "4.0.1"

#   create = false
# }

data "aws_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "us-east-2"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

  tags = {
    Example    = var.name
    GithubRepo = "toelt/bogus-gitops"
    Terraform = true
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.2"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]

  tags = local.tags
}