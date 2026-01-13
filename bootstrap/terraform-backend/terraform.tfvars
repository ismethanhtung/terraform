# Terraform backend configuration
environment      = "global"
project_name     = "project"
state_bucket_name = "project-infra-terraform-state"
lock_table_name   = "project-infra-terraform-lock"
billing_mode      = "PAY_PER_REQUEST"
hash_key          = "LockID"