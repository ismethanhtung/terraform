# --- environments/dev/outputs.tf ---

output "alb_dns_name" {
  description = "Truy cập Website tại đây"
  value       = "http://${module.compute.alb_dns_name}"
}

output "db_endpoint" {
  description = "Endpoint kết nối Database"
  value       = module.database.db_endpoint
}

output "s3_bucket_name" {
  description = "Tên S3 Bucket lưu trữ dữ liệu"
  value       = module.storage.bucket_name
}
