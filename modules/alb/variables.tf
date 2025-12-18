# --- modules/alb/variables.tf ---

variable "environment" {
  type = string
}

variable "project_name" {
  description = "Tên project dùng làm prefix cho tài nguyên ALB"
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_sg_id" {
  type = string
}

variable "health_check_path" {
  description = "Path cho health check của Target Group"
  type        = string
  default     = "/"
}
