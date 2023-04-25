/* 
  module "networking" {
  source = "./modules/networking"
} 
*/
/* 
module "ecs-fargate" {
  source = "./modules/services/ecs-fargate"
  cluster_id = module.ecs-fargate.cluster_id
}
 */

module "s3" {
  source = "./modules/s3"
}

/* 
  module "ecr" {
  source = "./modules/services/ecr"
} *
/

/* module "rds" {
  source = "./modules/services/rds"
  vpc_id = module.networking.vpc_id
  private_subnets = module.networking.private_subnets
} */