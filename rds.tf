resource "aws_db_instance" "tf_rds_mysql" {
  allocated_storage      = 10
  db_name                = "terraformdb"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  identifier             = "tf-mysql-db-instance"
  username               = "admin"
  password               = "admin123"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.tf-rds-sg.id]
}

resource "aws_security_group" "tf-rds-sg" {
  name        = "tf-rds-sg"
  description = "Security group for Terraform RDS instance"
  vpc_id      = "vpc-0b3300f0d88a79ba2"

  ingress {
    description     = "Allow MySQL access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = ["150.129.102.179/32"]
    security_groups = [aws_security_group.tf-security-group.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  rds_endpoint = element(split(":",aws_db_instance.tf_rds_mysql.endpoint), 0)
}

output "rds_endpoint" {
  value = local.rds_endpoint
}
output "rds_db_name" {
  value = aws_db_instance.tf_rds_mysql.db_name
}
output "rds_username" {
  value = aws_db_instance.tf_rds_mysql.username
}