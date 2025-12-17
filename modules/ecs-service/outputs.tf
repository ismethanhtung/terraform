output "service_name" {
  description = "Tên của ECS Service"
  value       = aws_ecs_service.this.name
}

output "service_id" {
  description = "ID của ECS Service"
  value       = aws_ecs_service.this.id
}

output "task_definition_arn" {
  description = "ARN của Task Definition"
  value       = aws_ecs_task_definition.this.arn
}
