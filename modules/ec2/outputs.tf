# --- modules/ec2/outputs.tf ---

output "id" {
  description = "ID của EC2 instance"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IP của instance (nếu có)"
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "Private IP của instance"
  value       = aws_instance.this.private_ip
}
