variable "environment" {
  description = "Tên môi trường (dev, prod...)"
  type        = string
}

variable "service_name" {
  description = "Tên của Service/Ứng dụng"
  type        = string
}

variable "cluster_id" {
  description = "ID của ECS Cluster"
  type        = string
}

variable "cluster_name" {
  description = "Tên của ECS Cluster (dùng cho Auto Scaling)"
  type        = string
}

variable "region" {
  description = "AWS Region (cho CloudWatch Logs)"
  type        = string
  default     = "ap-southeast-1"
}

# IAM Role Dependency
variable "execution_role_arn" {
  description = "ARN của IAM Role cho ECS Execution Agent"
  type        = string
}

variable "task_role_arn" {
  description = "ARN của IAM Role cho ECS Task"
  type        = string
}

# CloudWatch Dependency
variable "log_group_name" {
  description = "Tên Log Group để đẩy log"
  type        = string
}

# Network
variable "subnet_ids" {
  description = "Danh sách Subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Danh sách Security Group IDs cho ECS Task"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Gán Public IP?"
  type        = bool
  default     = false
}

# Container Config
variable "container_image" {
  description = "Docker image URI"
  type        = string
}

variable "container_port" {
  description = "Port mà container lắng nghe"
  type        = number
  default     = 80
}

variable "cpu" {
  description = "CPU units"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory (MiB)"
  type        = number
  default     = 512
}

variable "environment_variables" {
  description = "Biến môi trường"
  type        = map(string)
  default     = {}
}

# Load Balancer
variable "target_group_arn" {
  description = "ARN của Target Group (nếu có)"
  type        = string
  default     = null
}

# Scaling
variable "desired_count" {
  description = "Số lượng task mong muốn ban đầu"
  type        = number
  default     = 1
}

variable "enable_autoscaling" {
  description = "Bật Auto Scaling không?"
  type        = bool
  default     = false
}

variable "min_capacity" {
  description = "Số lượng task tối thiểu"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Số lượng task tối đa"
  type        = number
  default     = 2
}

variable "cpu_target_value" {
  description = "% CPU trigger scale"
  type        = number
  default     = 70
}

variable "memory_target_value" {
  description = "% Memory trigger scale"
  type        = number
  default     = 80
}

variable "tags" {
  description = "Tags chung"
  type        = map(string)
  default     = {}
}
