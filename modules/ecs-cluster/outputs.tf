output "cluster_id" {
  description = "ID của ECS Cluster"
  value       = aws_ecs_cluster.this.id
}

output "cluster_name" {
  description = "Tên của ECS Cluster"
  value       = aws_ecs_cluster.this.name
}

output "cluster_arn" {
  description = "ARN của ECS Cluster"
  value       = aws_ecs_cluster.this.arn
}
