module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.10.1"

  bucket = "tf-bucket-created"

  versioning = {
    enabled = false
  }

}