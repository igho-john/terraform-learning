variable "subnet_id" {
  description = "Subnet ID"
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
  description = "Your public IP with /32"
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

variable "image_name" {
  description = "AMI image name filter"
  type        = string
}

variable "myapp_sg_id" {
  description = "Security group ID from root module"
  type        = string
}