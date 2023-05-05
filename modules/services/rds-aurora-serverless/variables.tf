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

variable "vpc_id" {
  type = string
  default = ""
}