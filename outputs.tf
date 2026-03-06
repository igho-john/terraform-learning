output "aws_ami_id" {
  description = "The AMI ID of the Amazon Linux image"
  value       = module.myapp-webserver.aws_ami_id
}

output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = module.myapp-webserver.ec2_public_ip
}