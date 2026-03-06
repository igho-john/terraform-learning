variable "vpc_id" {
  description = "VPC ID"
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

variable "vpc_default_route_table_id" {
  description = "Default route table ID of the VPC"
  type        = string
}