data "aws_availability_zones" "available" {}

locals {
  region = "us-east-2"
  name   = "ex-${basename(path.cwd)}"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  container_name = "ecsdemo-frontend"
  container_port = 3000

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-ecs"
  }
}

module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.0.0"

  cluster_name = local.name

  # Capacity provider
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {}
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {}
    }
  }
}

module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.0.0"

  name        = local.name
  cluster_arn = var.cluster_arn.arn

  cpu    = 1024
  memory = 4096

  # Container definition(s)
  container_definitions = {
    (local.container_name) = {
      cpu       = 512
      memory    = 1024
      essential = true
      image     = "public.ecr.aws/aws-containers/ecsdemo-frontend:776fd50"
      port_mappings = [
        {
          name          = local.container_name
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
/* 
  load_balancer = {
    service = {
      target_group_arn = element(module.alb.target_group_arns, 0)
      container_name   = local.container_name
      container_port   = local.container_port
    }
  } */
/* 
  subnet_ids = module.vpc.private_subnets
  security_group_rules = {
    alb_ingress_3000 = {
      type                     = "ingress"
      from_port                = local.container_port
      to_port                  = local.container_port
      protocol                 = "tcp"
      description              = "Service port"
      source_security_group_id = module.alb_sg.security_group_id
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  } */
}
/* 
data "aws_ssm_parameter" "fluentbit" {
  name = "/aws/service/aws-for-fluent-bit/stable"
}

resource "aws_service_discovery_http_namespace" "this" {
  name        = local.name
  description = "CloudMap namespace for ${local.name}"
  tags        = local.tags
} */
/*
module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "${local.name}-service"
  description = "Service security group"
  vpc_id      = module.vpc.vpc_id

  ingress_rules       = ["http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = module.vpc.private_subnets_cidr_blocks

  tags = local.tags
}
*/
/*
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = local.name

  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.alb_sg.security_group_id]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    },
  ]

  target_groups = [
    {
      name             = "${local.name}-${local.container_name}"
      backend_protocol = "HTTP"
      backend_port     = local.container_port
      target_type      = "ip"
    },
  ]

  tags = local.tags
}
*/
/* 
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags
}
 */