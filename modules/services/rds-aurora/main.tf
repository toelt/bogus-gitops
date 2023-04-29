# Random id generator
/* module random {
  source = ""
  version = "3.5.1"

  keepers = {
    # Generate a new id each time we switch to a new AMI id
    ami_id = var.ami_id
  }

  byte_length = 8

} */

# resource "random_id" "db-pass" {
#   keepers = {
#     # Generate a new id each time we switch to a new AMI id
#     random_id =  ""
#   }

#   byte_length = 8
# }

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Secret to store the password
resource "aws_secretsmanager_secret" "db-pass" {
 name = "db-pass-${var.random_id}"
}

# Initial value of
# resource "aws_secretsmanager_secret_version" "db-pass-val" {
#   secret_id = aws_secretsmanager_secret.db-pass.id
#   secret_string = jsonencode(
#     {
#       username = var.db_username
#       password = var.db_master_pass
#       engine   = var.engine
#       host     = var.cluster_endpoint
#     }
#   )
# }
 
# Aurora cluster
module "aurora" {
  source  = "claranet/aurora/aws"
  version = "4.1.0"
  
  envname = "dev"
  envtype = "dev"
  
  name = "tf_bogus"
  engine = "aurora-mysql"
  engine-version = "5.7"
  instance_type = "db.t2.small"
  password = random_password.password.result
  azs = var.azs
  subnets = ["subnet-0e03ad310876394fb","subnet-030d5d6a6b6a1a806"]
  security_groups = var.security_groups

  skip_final_snapshot = "true"

  db_cluster_parameter_group_name ="default.aurora-mysql5.7"

  db_parameter_group_name ="default.aurora-mysql5.7"

}
/*

resource "null_resource" "db_setup" {
  triggers = {
    file = filesha1("initial.sql")
  }
  provisioner "local-exec" {
    command = <<-EOF
			while read line; do
				echo "$line"
				aws rds-data execute-statement --resource-arn "$DB_ARN" --database  "$DB_NAME" --secret-arn "$SECRET_ARN" --sql "$line"
			done  < <(awk 'BEGIN{RS=";\n"}{gsub(/\n/,""); if(NF>0) {print $0";"}}' initial.sql)
			EOF
    environment = {
      DB_ARN     = aws_rds_cluster.cluster.arn
      DB_NAME    = aws_rds_cluster.cluster.database_name
      SECRET_ARN = aws_secretsmanager_secret.db-pass.arn
    }
    interpreter = ["bash", "-c"]
  }
}
 */

