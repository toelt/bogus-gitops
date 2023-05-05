# output "vpc_id" {
#   description = "The ID of the VPC"
#   value       = var.vpc_id
# }

# output "private_subnets" {
#   description = "List of IDs of private subnets"
#   value       = var.private_subnets
# }
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnets
}