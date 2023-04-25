module "networking" {
  source = "./modules/networking"
}

module "ecs-fargate" {
  source = "./modules/services/ecs-fargate"
  vpc_id = module.networking.vpc_id
}

/* module "rds" {
  source = "./modules/services/rds"
  vpc_id = module.networking.vpc_id
  private_subnets = module.networking.private_subnets
} */