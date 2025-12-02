# --- modules/security-group/main.tf ---

# 1. Security Group cho Application Load Balancer (ALB)
resource "aws_security_group" "alb_sg" {
  name        = "${var.environment}-alb-sg"
  description = "Security Group for Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

# 2. Security Group cho Bastion Host
resource "aws_security_group" "bastion_sg" {
  name        = "${var.environment}-bastion-sg"
  description = "Security Group for Bastion Host"
  vpc_id      = var.vpc_id

  # Cho phép SSH từ mọi nơi (Thực tế nên giới hạn IP cụ thể)
  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-bastion-sg"
    Environment = var.environment
  }
}

# 3. Security Group cho Application Servers (EC2)
resource "aws_security_group" "app_sg" {
  name        = "${var.environment}-app-sg"
  description = "Security Group for Application Servers"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow HTTP from ALB only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  
  # Cho phép SSH từ Bastion Host
  ingress {
    description     = "Allow SSH from Bastion Host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
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

# 4. Security Group cho Database (RDS)
resource "aws_security_group" "db_sg" {
  name        = "${var.environment}-db-sg"
  description = "Security Group for Database"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow PostgreSQL from App Server"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  # Cho phép truy cập từ Bastion Host để debug DB (Optional)
  ingress {
    description     = "Allow PostgreSQL from Bastion Host"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  tags = {
    Name        = "${var.environment}-db-sg"
    Environment = var.environment
  }
}
