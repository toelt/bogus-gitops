locals {
  region = "us-east-2"
  name   = "ecr-${replace(basename(path.cwd), "_", "-")}"

  tags = {
    ManagedBy = "Terraform"
    Project = "Bogus GitOps"
  }
  }

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "1.6.0"
  repository_name = "bogus-services-nginx"

  repository_image_tag_mutability = "MUTABLE"

  repository_image_scan_on_push = false

  # repository_read_write_access_arns = [data.aws_caller_identity.current.arn]
  create_lifecycle_policy           = true
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 3 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 3
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  repository_force_delete = true
}