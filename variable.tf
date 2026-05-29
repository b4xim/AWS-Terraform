variable "ami_id" {
  type = string
  description = "Ami id"
  default = "ami-091138d0f0d41ff90"
}
variable "instance_type" {
  type = string
  description = "EC2 instance type"
  default = "t2.micro"
}
variable "vpc_id" {
  type = string
  description = "VPC id"
  default = "vpc-0b3300f0d88a79ba2"
}