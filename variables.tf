variable "region" {
  default     = "us-east-2"
  description = "AWS region"

  tags_all = {
    "Managed by" = "TF"
  }
}