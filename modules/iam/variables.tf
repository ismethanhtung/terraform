variable "environment" {
  description = "Tên môi trường"
  type        = string
}

variable "tags" {
  description = "Tags cho resources"
  type        = map(string)
  default     = {}
}

