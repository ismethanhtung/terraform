variable "name" {
  description = "Tên của ECS Cluster"
  type        = string
}

variable "container_insights" {
  description = "Bật Container Insights để monitoring (tốn thêm chi phí)"
  type        = bool
  default     = true
}

variable "log_group_name" {
  description = "Tên Log Group cho Cluster (Optional)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags cho các resources"
  type        = map(string)
  default     = {}
}
