module "terraform_state_bucket" {
  source      = "../../modules/s3"
  environment = "global"
  project_name = "polymarket"
  bucket_name = "polymarket-infra-terraform-state"
}

module "terraform_lock_table" {
  source       = "../../modules/dynamodb"
  environment  = "global"
  table_name   = "polymarket-infra-terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
}

output "state_bucket_name" {
  description = "Tên bucket dùng làm remote state"
  value       = module.terraform_state_bucket.bucket_name
}

output "lock_table_name" {
  description = "Tên DynamoDB table dùng làm state lock"
  value       = module.terraform_lock_table.table_name
}
