
resource "aws_instance" "terraform-project" {
  ami           = "ami-091138d0f0d41ff90"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [ aws_security_group.tf-security-group.id ]
  key_name      = "terraform-key"
  depends_on = [aws_s3_bucket.tf_s3]
  user_data = <<-EOF
              #!/bin/bash
              git clone https://github.com/verma-kunal/nodejs-mysql.git /home/ubuntu/nodejs-app
              cd /home/ubuntu/nodejs-app

              sudo apt update -y
              sudo apt install -y nodejs npm

              echo "DB_HOST=${local.rds_endpoint}" | sudo tee .env
              echo "DB_USER=${aws_db_instance.tf_rds_mysql.username}" | sudo tee -a .env
              sudo echo "DB_PASS=${aws_db_instance.tf_rds_mysql.password}" | sudo tee -a .env
              echo "DB_NAME=${aws_db_instance.tf_rds_mysql.db_name}" | sudo tee -a .env
              echo "TABLE_NAME=users" | sudo tee -a .env
              echo "PORT=3000" | sudo tee -a .env

              npm install
              EOF
  user_data_replace_on_change = true
  tags = {
    Name        = "NodeJs-Server"
    Environment = "Dev"
  }
  
  
}


resource "aws_security_group" "tf-security-group" {
  name        = "nodejs-tf-sg"
  description = "Security group for Terraform EC2 instance for SSH and HTTP access"
  vpc_id      = "vpc-0b3300f0d88a79ba2"
    ingress {
        description      = "Allow SSH"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress {
        description      = "TLS From VPC"
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress {
        description      = "TCP for NodeJS" 
        from_port        = 3000
        to_port          = 3000
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }
    egress {
        description      = "Allow all outbound traffic"
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }
}
output "instance_public_ip" {
  value = "ssh -i ~/.ssh/terraform-key.pem ubuntu@${aws_instance.terraform-project.public_ip}"
}