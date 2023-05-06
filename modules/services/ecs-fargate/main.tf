data "aws_availability_zones" "available" {}

locals {
  region = "us-east-2"
  name   = "ex-${basename(path.cwd)}"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

  # container_name = local.name
  # container_port = 3000

}


module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "5.0.0"

  cluster_name = "ecs-fargate"
  

  fargate_capacity_providers = {
    FARGATE = {
      weight = 1
    }
    FARGATE_SPOT = {}
  }
}

resource "aws_ecs_task_definition" "test" {
  family                   = "test"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "nginx",
    "image": "450494728275.dkr.ecr.us-east-2.amazonaws.com/nginx",
    "cpu": 1024,
    "memory": 2048,
    "essential": true
  }
]
TASK_DEFINITION

execution_role_arn = "arn:aws:iam::450494728275:role/ecsTaskExecutionRole"

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_ecs_service" "test" {
  name = "nginx"
  cluster = "arn:aws:ecs:us-east-2:450494728275:cluster/ecs-fargate"
  task_definition = "arn:aws:ecs:us-east-2:450494728275:task-definition/test:2"

  launch_type = "FARGATE"

  
  network_configuration {
    subnets = [ "subnet-0e03ad310876394fb","subnet-030d5d6a6b6a1a806" ]
    assign_public_ip = false
  }
  depends_on = [ aws_ecs_task_definition.test ]
}