//Resources:
// vpc + public subnet + igw + route table +  route table assoc +
// nacl + eip + security group
// Get AZs + your IP
data "aws_availability_zones" "zones" {}
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

// vpc
resource "aws_vpc" "main" {
  cidr_block           = var.cird_range
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project}-vpc"
    Env  = var.env
  }
}
// public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.cird_range, 8, 0)
  availability_zone       = element(data.aws_availability_zones.zones.names, 0)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project}-public"
    Env  = var.env
  }
}
// IGW for the public subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project}-igw"
    Env  = var.env
  }
}
// Route table for subnet(s)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
// Explicitely associate the newly created route tables to the private subnets (so they don't default to the main route table)
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
// NACL
resource "aws_network_acl" "allowall" {
  vpc_id = aws_vpc.main.id
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "${chomp(data.http.myip.body)}/32"
    from_port  = 22
    to_port    = 22
  }
}
// Create an eip for ec2 instance
resource "aws_eip" "gw" {
  vpc        = true
  instance = aws_instance.app_instance.id
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "${var.project}-eip"
    Env  = var.env
  }
}
// Security group
resource "aws_security_group" "allow_ssh" {
  vpc_id      = aws_vpc.main.id
  name        = "allow_ssh"
  description = "The sg which allows ssh and all egress traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }
  tags = {
    Name = "${var.project}-sg"
    Env  = var.env
  }
}

