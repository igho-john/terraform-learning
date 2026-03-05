provider "aws" {
  region = "ca-central-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "subnet_cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
}
variable "avail_zone" {
  description = "Availability zone"
  type        = string
}
variable "env_prefix" {
  description = "Environment prefix"
  type        = string
}

variable "my_ip" {
  description = "ip address"
  type        = string
}
variable "instance_type" {
  description = "Instance type"
  type        = string
}
variable "public_key_location" {
  description = "Path to public key"
  type        = string
}


resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id            = aws_vpc.myapp-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name = "${var.env_prefix}-subnet-1"
  }
}

resource "aws_internet_gateway" "myapp-gw" {
  vpc_id = aws_vpc.myapp-vpc.id

  tags = {
    Name = "${var.env_prefix}-myapp-gw"
  }
}


resource "aws_default_route_table" "myapp-df-rt" {
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id 

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-gw.id
  }

  tags = {
    Name = "${var.env_prefix}-myapp-df-rt"
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

data "aws_ami" "amazon-linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  owners = ["137112412989"] # Amazon official account
} 
resource "aws_key_pair" "ssh-key-pair" {
  key_name   = "testing-v2"
  public_key = file(var.public_key_location)
}


resource "aws_instance" "myapp-server" {
  ami           = data.aws_ami.amazon-linux.id
  instance_type = var.instance_type

  subnet_id                   = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids      = [aws_security_group.myapp-sg.id]
  availability_zone           = var.avail_zone
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh-key-pair.key_name

  user_data = file("entry-script.sh")


  tags = {
    Name = "${var.env_prefix}-server"
  }
}