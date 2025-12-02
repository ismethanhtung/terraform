variable "name" {
  description = "Tên của EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID cho instance"
  type        = string
}

variable "instance_type" {
  description = "Loại instance (ví dụ: t3.micro)"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID để đặt instance vào"
  type        = string
}

variable "security_group_ids" {
  description = "Danh sách Security Group IDs"
  type        = list(string)
}

variable "key_name" {
  description = "Tên Key Pair để SSH (nếu có)"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Gán Public IP hay không"
  type        = bool
  default     = false
}

variable "user_data" {
  description = "Script user data để chạy khi khởi tạo instance"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags bổ sung"
  type        = map(string)
  default     = {}
}
