module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "5.0.0"

  cluster_name = "ecs-fargate"

  fargate_capacity_providers = {
    FARGATE = {}
    FARGATE_SPOT = {}
  }
}