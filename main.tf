# YOU CAN'T DEPLOY ANYTHING BEFORE YOU HAVE CONFIGURED LIFECYCLE FOR ELASTIC IP, NAT GATEWAY ETC!

module "vpc" {
  source = "./modules/vpc"
}

# module "ecr" {
#   source = "./modules/services/ecr"
# }

# module "ecs-fargate" {
#   source = "./modules/services/ecs-fargate"
# }

# module "s3" {
#   source = "./modules/services/s3"
# }

# module "rds-aurora" {
#   source = "./modules/services/rds-aurora"
#   # vpc_id = module.networking.vpc_id
#   # private_subnets = module.networking.private_subnets
# }
