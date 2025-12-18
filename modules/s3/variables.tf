# --- modules/s3/variables.tf ---

variable "environment" {
  type = string
}

variable "project_name" {
  description = "Tên project dùng cho đặt tag/tên resource"
  type        = string
}

variable "bucket_name" {
  description = "Tên chính xác của bucket. Nếu được cung cấp, random_id sẽ không được sử dụng trong tên."
  type        = string
  default     = null
}

variable "bucket_prefix" {
  description = "Tiền tố cho tên bucket nếu bucket_name không được cung cấp."
  type        = string
  default     = "data"
}
