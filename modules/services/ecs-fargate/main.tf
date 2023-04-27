data "aws_availability_zones" "available" {}

locals {
  region = "us-east-2"
  name   = "ex-${basename(path.cwd)}"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

  container_name = "pinger"
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

resource "aws_ecs_task_definition" "test" {
  family                   = "test"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048

  container_definitions = jsonencode([
    {
      name      = "first"
      image     = "service-first"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    },
    {
      name      = "second"
      image     = "service-second"
      cpu       = 10
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 443
          hostPort      = 443
        }
      ]
    }
  ])

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}
/* module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.0.0"

  name        = "pinger-service"
  cluster_arn = "arn:aws:ecs:us-east-2:450494728275:cluster/ecs-fargate"

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