# --- modules/networking/variables.tf ---

variable "environment" {
  description = "Môi trường triển khai (dev, prod, staging)"
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
