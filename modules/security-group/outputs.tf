# --- modules/security-group/outputs.tf ---

output "alb_sg_id" {
  description = "ID của Security Group cho ALB"
  value       = aws_security_group.alb_sg.id
}

output "bastion_sg_id" {
  description = "ID của Security Group cho Bastion Host"
  value       = aws_security_group.bastion_sg.id
}

output "app_sg_id" {
  description = "ID của Security Group cho App Server"
  value       = aws_security_group.app_sg.id
}

output "db_sg_id" {
  description = "ID của Security Group cho Database"
  value       = aws_security_group.db_sg.id
}
