# variable "vpc_id" {
#   description = "The ID of the VPC"
#   value       = ""
# }

# variable "private_subnets" {
#   description = "List of IDs of private subnets"
#   value       = []
# }
variable "ami_id" {
    type = string
    default = ""
}

variable "random_id" {
  type = string
  default = ""
}