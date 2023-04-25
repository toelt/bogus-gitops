provider "aws" {
  region = local.region
}

locals {
  region = "us-east-2"
  name   = "ecs-ex-${replace(basename(path.cwd), "_", "-")}"
/* 
  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-ecs"
     */
}

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.0.0"

  cluster_name = local.name

  default_capacity_provider_use_fargate = true
  # Capacity provider
  fargate_capacity_providers = {
    FARGATE = {}
    FARGATE_SPOT = {}

  # tags = local.tags
  }
}

module "hello_world" {
  source = "./service-hello-world"
  cluster_id = var.cluster_id
}
/*
module "ecs_disabled" {
  source = "../.."

  create = false
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/ecs/${local.name}"
  retention_in_days = 7

  tags = local.tags
}
*/