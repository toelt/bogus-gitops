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
  default = ""
}

variable "db_username" {
  type = string
  default = ""
  
}

variable "db_master_pass" {
  type = string
  default = ""
}

variable "engine" {
  type = string
  default = ""
}

variable "cluster_endpoint" {
  type = string
  default = null
}

variable "private_subnet_ids" {
  type = list(string)
  default = []
}

variable "azs" {
  type = list(string)
  default = []
}

variable "security_groups" {
  type = list(string)
  default = []
}