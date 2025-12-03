output "instance_id" {
  description = "ID của EC2 instance"
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "Private IP của EC2 instance"
  value       = aws_instance.this.private_ip
}

output "public_ip" {
  description = "Public IP của EC2 instance (nếu có)"
  value       = aws_instance.this.public_ip
}

output "availability_zone" {
  description = "Availability Zone của EC2 instance"
  value       = aws_instance.this.availability_zone
}
