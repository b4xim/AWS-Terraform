
resource "aws_instance" "terraform-project" {
  ami           = "ami-091138d0f0d41ff90"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [ aws_security_group.tf-security-group.id ]
  key_name      = "terraform-key"
  depends_on = [aws_s3_bucket.tf_s3]
  
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