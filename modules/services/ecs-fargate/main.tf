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

resource "aws_ecs_task_definition" "tf_test_nginx" {
  family                   = "tf-bogus-nginx"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "tf-bogus-nginx",
    "image": "nginx:latest",
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

resource "aws_ecs_service" "tf_test_nginx" {
  name = "tf-bogus-nginx"
  cluster = "arn:aws:ecs:us-east-2:450494728275:cluster/ecs-fargate"
  task_definition = "arn:aws:ecs:us-east-2:450494728275:task-definition/tf-bogus-nginx:1arn:aws:ecs:us-east-2:450494728275:task-definition/tf-bogus-nginx:1"

  launch_type = "FARGATE"

  desired_count = 1
  
  network_configuration {
    subnets = [ "subnet-0cbcced3a58e34aa0","subnet-04d30015347c1fa42" ]
    assign_public_ip = false
  }
  depends_on = [ aws_ecs_task_definition.tf_test_nginx ]
}