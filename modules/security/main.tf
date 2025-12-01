# --- modules/security/main.tf ---

# 1. Security Group cho Application Load Balancer (ALB)
# Cho phép truy cập từ Internet vào ALB.
resource "aws_security_group" "alb_sg" {
  name        = "${var.environment}-alb-sg"
  description = "Security Group for Application Load Balancer"
  vpc_id      = var.vpc_id

  # Inbound Rule: Cho phép HTTP (Port 80) từ mọi nơi
  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound Rule: Cho phép HTTPS (Port 443) từ mọi nơi (nếu có SSL)
  ingress {
    description = "Allow HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Rule: Cho phép ra ngoài thoải mái
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-alb-sg"
    Environment = var.environment
  }
}

# 2. Security Group cho Application Servers (EC2)
# Chỉ cho phép traffic từ ALB, không cho phép truy cập trực tiếp từ Internet.
resource "aws_security_group" "app_sg" {
  name        = "${var.environment}-app-sg"
  description = "Security Group for Application Servers"
  vpc_id      = var.vpc_id

  # Inbound Rule: Chỉ nhận traffic từ ALB Security Group
  ingress {
    description     = "Allow HTTP from ALB only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # Chaining Security Groups
  }
  
  # Inbound Rule: Cho phép SSH từ Bastion Host (nếu có - ở đây giả lập mở port 22 trong VPC)
  ingress {
    description = "Allow SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-app-sg"
    Environment = var.environment
  }
}

# 3. Security Group cho Database (RDS)
# Chỉ cho phép traffic từ Application Servers.
resource "aws_security_group" "db_sg" {
  name        = "${var.environment}-db-sg"
  description = "Security Group for Database"
  vpc_id      = var.vpc_id

  # Inbound Rule: Chỉ nhận traffic PostgreSQL (Port 5432) từ App Security Group
  ingress {
    description     = "Allow PostgreSQL from App Server"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  tags = {
    Name        = "${var.environment}-db-sg"
    Environment = var.environment
  }
}
