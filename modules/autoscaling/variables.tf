# --- modules/autoscaling/variables.tf ---

variable "environment" {
  type = string
}

variable "project_name" {
  description = "Tên project dùng làm prefix cho tài nguyên autoscaling"
  type        = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "app_sg_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "target_group_arns" {
  type = list(string)
}

variable "asg_min_size" {
  type    = number
  default = 1
}

variable "asg_max_size" {
  type    = number
  default = 3
}

variable "asg_desired_capacity" {
  type    = number
  default = 2
}
