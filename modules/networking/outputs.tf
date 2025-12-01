# --- modules/networking/outputs.tf ---

output "vpc_id" {
  description = "ID của VPC được tạo"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Danh sách ID của các Public Subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Danh sách ID của các Private Subnets"
  value       = aws_subnet.private[*].id
}

output "vpc_cidr_block" {
  description = "CIDR block của VPC"
  value       = aws_vpc.main.cidr_block
}
