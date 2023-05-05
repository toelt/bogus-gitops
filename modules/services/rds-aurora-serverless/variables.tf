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
  default = [""]
}

variable "vpc_id" {
  type = string
  default = "vpc-000b901341cf23bc3"
}

variable "private_subnets_cidr_blocks" {
  type = list(string)
  default = [ "10.0.16.0/20","10.0.0.0/20" ]
}

variable "database_subnet_group_name" {
  type = string
  default = ""
}