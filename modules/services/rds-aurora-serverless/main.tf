data "aws_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "us-east-2"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Example    = local.name
    ManagedBy  = "Terraform"
    GithubRepo = "terraform-aws-rds-aurora"
    GithubOrg  = "terraform-aws-modules"
  }
}

################################################################################
# PostgreSQL Serverless v1
################################################################################

# module "aurora_postgresql" {
#   source  = "terraform-aws-modules/rds-aurora/aws"
#   version = "8.0.2"

#   create = false

#   name              = "${local.name}-postgresql"
#   engine            = "aurora-postgresql"
#   engine_mode       = "serverless"
#   storage_encrypted = true

#   vpc_id               = module.vpc.vpc_id
#   db_subnet_group_name = module.vpc.database_subnet_group_name
#   security_group_rules = {
#     vpc_ingress = {
#       cidr_blocks = module.vpc.private_subnets_cidr_blocks
#     }
#   }

#   monitoring_interval = 60

#   apply_immediately   = true
#   skip_final_snapshot = true

#   # enabled_cloudwatch_logs_exports = # NOT SUPPORTED

#   scaling_configuration = {
#     auto_pause               = true
#     min_capacity             = 2
#     max_capacity             = 16
#     seconds_until_auto_pause = 300
#     timeout_action           = "ForceApplyCapacityChange"
#   }
# }

################################################################################
# MySQL Serverless v1
################################################################################

# module "aurora_mysql" {
#   source  = "terraform-aws-modules/rds-aurora/aws"
#   version = "8.0.2"

#   create = false

#   # name              = "${local.name}-mysql"
#   # engine            = "aurora-mysql"
#   # engine_mode       = "serverless"
#   # storage_encrypted = true

#   # vpc_id               = 
#   # db_subnet_group_name = database_subnet_group_name
#   # security_group_rules = {
#   #   vpc_ingress = {
#   #     cidr_blocks = 
#   #   }
#   # }

#   monitoring_interval = 60

#   apply_immediately   = true
#   skip_final_snapshot = true

#   # enabled_cloudwatch_logs_exports = # NOT SUPPORTED

#   scaling_configuration = {
#     auto_pause               = true
#     min_capacity             = 2
#     max_capacity             = 16
#     seconds_until_auto_pause = 300
#     timeout_action           = "ForceApplyCapacityChange"
#   }

#   tags = local.tags
# }

################################################################################
# MySQL Serverless v2
################################################################################

module "aurora_mysql_v2" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "8.0.2"

  create = true

  name              = "${local.name}-mysqlv2"
  engine            = "aurora-mysql"
  engine_mode       = "provisioned"
  engine_version    = "8.0"
  storage_encrypted = true

  vpc_id               = var.vpc_id
  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = var.private_subnets_cidr_blocks
    }
  }

  monitoring_interval = 60

  apply_immediately   = true
  skip_final_snapshot = true

  serverlessv2_scaling_configuration = {
    min_capacity = 0.5
    max_capacity = 2
  }

  instance_class = "db.serverless"
  instances = {
    bogus = {}
  }
}

################################################################################
# PostgreSQL Serverless v2
################################################################################

# data "aws_rds_engine_version" "postgresql" {
#   engine  = "aurora-postgresql"
#   version = "14.5"
# }

# module "aurora_postgresql_v2" {
#   source  = "terraform-aws-modules/rds-aurora/aws"
#   version = "8.0.2"

#   create = false

#   name              = "${local.name}-postgresqlv2"
#   engine            = data.aws_rds_engine_version.postgresql.engine
#   engine_mode       = "provisioned"
#   engine_version    = data.aws_rds_engine_version.postgresql.version
#   storage_encrypted = true

#   vpc_id               = module.vpc.vpc_id
#   db_subnet_group_name = module.vpc.database_subnet_group_name
#   security_group_rules = {
#     vpc_ingress = {
#       cidr_blocks = module.vpc.private_subnets_cidr_blocks
#     }
#   }

#   monitoring_interval = 60

#   apply_immediately   = true
#   skip_final_snapshot = true

#   serverlessv2_scaling_configuration = {
#     min_capacity = 2
#     max_capacity = 10
#   }

#   instance_class = "db.serverless"
#   instances = {
#     one = {}
#     two = {}
#   }
# }
