# --- modules/compute/outputs.tf ---

output "alb_dns_name" {
  description = "DNS Name của Load Balancer (Truy cập web qua link này)"
  value       = aws_lb.main.dns_name
}

output "asg_name" {
  description = "Tên của Auto Scaling Group"
  value       = aws_autoscaling_group.main.name
}
