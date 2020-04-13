// Env/Project vars
variable "project" {
  default     = "ec2-test"
  description = "The project name"
}
variable "env" {
  default     = "dev"
  description = "The environment var"
}
variable "shared_credentials_file" {
  default     = "~/.aws/credentials"
  description = "The shared credentials file location"
}
variable "profile" {
  description = "The shared credentials configured IAM user profile"
}
variable "public_key" {
  default = "~/.ssh/id_rsa.pub"
  description = "The shared credentials configured IAM user profile"
}
variable "aws_region" {
  default     = "eu-west-3"
  description = "The AWS region to deploy resources in."
}
variable "cird_range" {
  default     = "10.0.0.0/16"
  description = "The desired VPC's ip range"
}
variable "instance_type" {
  default     = "t2.micro"
  description = "EC2 instance type"
}

