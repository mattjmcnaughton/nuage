output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.instance.id
}

output "private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.instance.private_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.instance_sg.id
}
