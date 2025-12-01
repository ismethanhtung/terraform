# --- modules/database/variables.tf ---

variable "environment" {
  type = string
}

variable "private_subnet_ids" {
  description = "Danh sách ID của Private Subnets"
  type        = list(string)
}

variable "db_sg_id" {
  description = "ID của Security Group cho Database"
  type        = string
}

variable "db_instance_class" {
  description = "Loại instance cho RDS (ví dụ: db.t3.micro)"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Tên database"
  type        = string
}

variable "db_username" {
  description = "Username quản trị DB"
  type        = string
}

variable "db_password" {
  description = "Password quản trị DB"
  type        = string
  sensitive   = true # Đánh dấu là dữ liệu nhạy cảm, không hiện trong log
}

variable "multi_az" {
  description = "Bật chế độ Multi-AZ hay không"
  type        = bool
  default     = false
}
