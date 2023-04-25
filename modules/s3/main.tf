module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.8.2"

  bucket = "my-s3-bucket"
  acl    = "private"

  versioning = {
    enabled = false
  }
}