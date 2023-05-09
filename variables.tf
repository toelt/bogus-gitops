variable "region" {
  default     = "us-east-2"
  description = "AWS region"
}

# variable "resource_tags" {
#   description = "Tags to set for all resources"
#   type        = map(string)
#   default     = {
#     project     = "bogus-gitops",
#     environment = "dev"
#   }