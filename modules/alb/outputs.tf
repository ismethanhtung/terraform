output "target_group_arn" {
  description = "ARN của Target Group"
  value       = aws_lb_target_group.main.arn
}

output "alb_dns_name" {
  description = "DNS name của Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "ARN của Load Balancer"
  value       = aws_lb.main.arn
}

output "listener_arn" {
  description = "ARN của Listener"
  value       = aws_lb_listener.http.arn
}
