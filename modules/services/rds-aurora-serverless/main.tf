data "aws_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "us-east-2"

  vpc_cidr = "10.0.0.0/16"
  azs      = ["us-east-2a","us-east-2b"]
           # slice(data.aws_availability_zones.available.names, 0, 3)
}

module "aurora_mysql_v2" {
  source  = "terraform-aws-modules/rds-aurora/aws//examples/serverless"
  version = "8.0.2"

  name              = "${local.name}-mysqlv2"
  engine            = "aurora-mysql"
  engine_mode       = "provisioned"
  engine_version    = "8.0"
  storage_encrypted = true

  vpc_id               = "vpc-037331c2d23a6d618"
  db_subnet_group_name = "tf_bogus"
                       # module.vpc.database_subnet_group_name
  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = ["10.0.8.0/24","10.0.9.0/24"]
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
    db_one = {}
  }
}