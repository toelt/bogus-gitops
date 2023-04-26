data "aws_availability_zones" "available" {}

locals {
  region = "us-east-2"
  name   = "ex-${basename(path.cwd)}"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

  container_name = "ecsdemo-pinger"
  container_port = 3000

}

module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "5.0.0"

  cluster_name = "ecs-fargate"

  fargate_capacity_providers = {
    FARGATE = {}
    FARGATE_SPOT = {}
  }
}

/* module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.0.0"

  name        = "pinger-service"
  cluster_arn = module.ecs_cluster.arn

  cpu    = 1024
  memory = 4096

  # Container definition(s)
  container_definitions = {

    (local.container_name) = {
      cpu       = 512
      memory    = 1024
      essential = true
      image     = "subfuzion/pinger:latest"
      port_mappings = [
        {
          name          = "pinger"
          containerPort = local.container_port
          hostPort      = local.container_port
          protocol      = "tcp"
        }
      ]

      # Example image used requires access to write to root filesystem
      readonly_root_filesystem = false

      enable_cloudwatch_logging = false
      memory_reservation = 100
  
    }
  }
} */