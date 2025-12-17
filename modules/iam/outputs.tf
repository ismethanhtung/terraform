output "execution_role_arn" {
  description = "ARN của ECS Execution Role"
  value       = aws_iam_role.execution_role.arn
}

output "task_role_arn" {
  description = "ARN của ECS Task Role"
  value       = aws_iam_role.task_role.arn
}

