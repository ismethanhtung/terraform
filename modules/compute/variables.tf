# --- modules/compute/variables.tf ---

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  description = "Subnets cho Load Balancer"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Subnets cho Application Servers"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security Group cho ALB"
  type        = string
}

variable "app_sg_id" {
  description = "Security Group cho App Servers"
  type        = string
}

variable "instance_type" {
  description = "Loại EC2 Instance"
  type        = string
  default     = "t3.micro"
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
