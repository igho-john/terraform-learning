output "subnet_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.myapp-subnet-1.id
}