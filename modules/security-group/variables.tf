# --- modules/security-group/variables.tf ---

variable "environment" {
  description = "Môi trường triển khai"
  type        = string
}

variable "vpc_id" {
  description = "ID của VPC"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block của VPC (để cho phép SSH nội bộ)"
  type        = string
}
