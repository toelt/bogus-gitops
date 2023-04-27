data "aws_availability_zones" "available" {}

locals {
  region = "us-east-2"
  name   = "ex-${basename(path.cwd)}"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

  container_name = local.name
  container_port = 3000

}


module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "5.0.0"

  cluster_name = "ecs-fargate"
  

  fargate_capacity_providers = {
    FARGATE_SPOT = {}
  }
}
/* 
resource "aws_ecs_task_definition" "test" {
  family                   = "test"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048

  container_definitions = jsonencode([
    {
      name      = "hello"
      image     = "450494728275.dkr.ecr.us-east-2.amazonaws.com/ecr-bogus-gitops:latest"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
} */
/* 
data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
} */
/* 
resource "aws_ecs_task_definition" "bogus-service" {
  family                   = ""
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = ""
  memory                   = ""
  task_role_arn            = ""
  execution_role_arn       = ""

  container_definitions = <<DEFINITION
  [
    {
      "cpu": 1024,
      "image": "450494728275.dkr.ecr.us-east-2.amazonaws.com/ecr-bogus-gitops:latest",
      "memory": 2048,
      "name": "ecr-image",
      "networkMode": "awsvpc"
    }
  ]
  DEFINITION
} */

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