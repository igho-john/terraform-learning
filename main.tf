provider "aws" {
  region = "ca-central-1"
}

resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_security_group" "myapp-sg" {
  name        = "myapp-sg"
  description = "for myapp security group"
  vpc_id      = aws_vpc.myapp-vpc.id

  tags = {
    Name = "${var.env_prefix}-myapp-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "myapp-sg-ssh" {
  security_group_id = aws_security_group.myapp-sg.id
  cidr_ipv4         = var.my_ip
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "myapp-sg-http" {
  security_group_id = aws_security_group.myapp-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_vpc_security_group_egress_rule" "myapp-sg-egress" {
  security_group_id = aws_security_group.myapp-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

module "myapp-subnet" {
  source = "./modules/subnet"

  subnet_cidr_block          = var.subnet_cidr_block
  vpc_id                     = aws_vpc.myapp-vpc.id
  vpc_default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
  avail_zone                 = var.avail_zone
  env_prefix                 = var.env_prefix
}

module "myapp-webserver" {
  source = "./modules/webserver"

  env_prefix          = var.env_prefix
  avail_zone          = var.avail_zone
  instance_type       = var.instance_type
  my_ip               = var.my_ip
  public_key_location = var.public_key_location
  image_name          = var.image_name
  subnet_id           = module.myapp-subnet.subnet_id
  myapp_sg_id         = aws_security_group.myapp-sg.id
}