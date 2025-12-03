# --- environments/dev/outputs.tf ---

output "alb_dns_name" {
  description = "Truy cập Website tại đây"
  value       = "http://${module.alb.alb_dns_name}"
}

output "api_gateway_url" {
  description = "URL của API Gateway"
  value       = aws_apigatewayv2_api.main.api_endpoint
}

output "db_endpoint" {
  description = "Private IP của Database EC2 (MSSQL)"
  value       = module.db.private_ip
}

output "s3_bucket_name" {
  description = "Tên S3 Bucket lưu trữ dữ liệu"
  value       = module.s3.bucket_name
}

output "backend_instance_id" {
  description = "ID của Backend EC2 instance"
  value       = module.backend.instance_id
}

output "db_instance_id" {
  description = "ID của DB EC2 instance"
  value       = module.db.instance_id
}
