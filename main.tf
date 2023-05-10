module "networking" {
  source = "./modules/networking"
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

# module "rds-aurora-serverless" {
#   source = "./modules/services/rds-aurora-serverless"
# }