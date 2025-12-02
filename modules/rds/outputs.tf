# --- modules/rds/outputs.tf ---

output "db_endpoint" {
  description = "Endpoint kết nối tới Database"
  value       = aws_db_instance.main.endpoint
}

output "db_name" {
  description = "Tên Database"
  value       = aws_db_instance.main.db_name
}
