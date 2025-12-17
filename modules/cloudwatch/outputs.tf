output "log_group_name" {
  description = "Tên của Log Group"
  value       = aws_cloudwatch_log_group.this.name
}

output "log_group_arn" {
  description = "ARN của Log Group"
  value       = aws_cloudwatch_log_group.this.arn
}

