# --- modules/rds/main.tf ---

# 1. DB Subnet Group
# Định nghĩa nhóm các subnet mà RDS có thể nằm trong đó (Private Subnets).
resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

# 2. RDS Instance (PostgreSQL)
resource "aws_db_instance" "main" {
  identifier        = "${var.environment}-${var.project_name}-db"
  engine            = "postgres"
  engine_version    = "13.7" # Phiên bản PostgreSQL
  instance_class    = var.db_instance_class
  allocated_storage = 20 # Dung lượng ổ cứng (GB)
  storage_type      = "gp2"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 5432

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.db_sg_id]

  multi_az            = var.multi_az # Bật/tắt chế độ Multi-AZ (Dự phòng)
  publicly_accessible = false      # Không cho phép truy cập từ Internet
  skip_final_snapshot = true       # Bỏ qua snapshot khi xóa (chỉ dùng cho môi trường Dev/Học tập)

  tags = {
    Name        = "${var.environment}-${var.project_name}-db"
    Environment = var.environment
  }
}
