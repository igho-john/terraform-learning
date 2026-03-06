output "aws_ami_id" {
  description = "The AMI ID of the Amazon Linux image"
  value       = data.aws_ami.amazon-linux.id
}

output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.myapp-server.public_ip
}