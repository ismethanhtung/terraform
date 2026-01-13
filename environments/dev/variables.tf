# --- environments/dev/variables.tf ---

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-1" # Singapore
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Tên dự án (dùng làm prefix cho tài nguyên)"
  type        = string
  default     = "project"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "instance_type" {
  type = string
}

variable "supabase_url" {
  description = "Supabase URL"
  type        = string
}

variable "supabase_key" {
  description = "Supabase API Key"
  type        = string
  sensitive   = true
}
