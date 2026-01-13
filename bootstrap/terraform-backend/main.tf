module "terraform_state_bucket" {
  source       = "../../modules/s3"
  environment  = var.environment
  project_name = var.project_name
  bucket_name  = var.state_bucket_name
}

module "terraform_lock_table" {
  source       = "../../modules/dynamodb"
  environment  = var.environment
  table_name   = var.lock_table_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key
}

