# --- modules/vpc/variables.tf ---

variable "environment" {
  description = "Môi trường triển khai (dev, prod, staging)"
  type        = string
}

variable "project_name" {
  description = "Tên project dùng làm prefix cho tài nguyên VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "Dải IP cho VPC (ví dụ: 10.0.0.0/16)"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Danh sách các CIDR block cho Public Subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Danh sách các CIDR block cho Private Subnets"
  type        = list(string)
}

variable "enable_nat" {
  description = "Bật/tắt NAT Gateway cho private subnets (tốn chi phí nếu bật)"
  type        = bool
  default     = false
}
