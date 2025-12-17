variable "log_group_name" {
  description = "Tên của Log Group"
  type        = string
}

variable "retention_in_days" {
  description = "Số ngày lưu trữ log"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags cho resources"
  type        = map(string)
  default     = {}
}

