module "ec2_disabled" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.5.0"

  create = false
}