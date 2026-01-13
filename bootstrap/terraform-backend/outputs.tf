output "state_bucket_name" {
  description = "Tên bucket dùng làm remote state"
  value       = module.terraform_state_bucket.bucket_name
}

output "lock_table_name" {
  description = "Tên DynamoDB table dùng làm state lock"
  value       = module.terraform_lock_table.table_name
}