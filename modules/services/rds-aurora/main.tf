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

resource "random_id" "db-pass" {
  keepers = {
    # Generate a new id each time we switch to a new AMI id
    random_id =  var.random_id
  }

  byte_length = 8
}

# Secret to store the password
resource "aws_secretsmanager_secret" "db-pass" {
 name = "db-pass-${random_id.id.hex}"
}

# Initial value of
resource "aws_secretsmanager_secret_version" "db-pass-val" {
  secret_id = aws_secretsmanager_secret.db-pass.id
  secret_string = jsonencode(
    {
      username = aws_rds_cluster.cluster.master_username
      password = aws_rds_cluster.cluster.master_password
      engine   = "mysql"
      host     = aws_rds_cluster.cluster.endpoint
    }
  )
}
/* 
# Aurora cluster
resource "aws_rds_cluster" "cluster" {
  engine               = "aurora-mysql"
  engine_version       = "5.7.mysql_aurora.2.07.1"
  engine_mode          = "serverless"
  database_name        = "mydb"
  master_username      = "admin"
  master_password      = random_password.db_master_pass.result
  enable_http_endpoint = false
  skip_final_snapshot  = true
  scaling_configuration {
    min_capacity = 1
  }
}

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

