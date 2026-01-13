variable "environment" {
  description = "Environment for resources"
  type        = string
  default     = "global"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "project"
}

variable "state_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
  default     = "project-infra-terraform-state"
}

variable "lock_table_name" {
  description = "Name of the DynamoDB table for Terraform state locking"
  type        = string
  default     = "project-infra-terraform-lock"
}

variable "billing_mode" {
  description = "Billing mode for DynamoDB table"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "Hash key for DynamoDB table"
  type        = string
  default     = "LockID"
}