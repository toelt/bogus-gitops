module "networking" {
  source = "./modules/networking"
}

module "rds" {
  source = "./modules/rds"
  vpc_id = module.networking.vpc_id
  private_subnets = module.networking.private_subnets
}