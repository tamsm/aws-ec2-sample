// ec2 provision example
provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = var.shared_credentials_file
  profile                 = var.profile
}
// Public key material
resource "aws_key_pair" "public_key" {
  key_name   = "${var.project}-public-key"
  public_key = file(var.public_key)
}
// Latest ubuntu 18 LTS AMI id
data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"] // CANONICAL
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu*18.04-amd64-server*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "app_instance" {
  ami                    = data.aws_ami.ubuntu.id
  availability_zone      = element(data.aws_availability_zones.zones.names, 0)
  subnet_id              = aws_subnet.public.id
  key_name               = aws_key_pair.public_key.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  instance_type          = var.instance_type
}
