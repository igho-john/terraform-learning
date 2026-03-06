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
  description = "Environment prefix e.g. dev, prod"
  type        = string
}

variable "my_ip" {
  description = "Your public IP address with /32"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "public_key_location" {
  description = "Path to public key file"
  type        = string
}

variable "private_key_location" {
  description = "Path to private key file"
  type        = string
}

variable "image_name" {
  description = "AMI image name filter"
  type        = string
}