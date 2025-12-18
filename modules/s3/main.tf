# --- modules/s3/main.tf ---

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "data" {
  bucket = var.bucket_name != null ? var.bucket_name : "${var.bucket_prefix}-${var.environment}-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = var.bucket_name != null ? var.bucket_name : "${var.project_name}-data-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Bật tính năng Versioning (Lưu lịch sử thay đổi file)
# Quan trọng cho dữ liệu y tế để tránh xóa nhầm.
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.data.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Mã hóa dữ liệu (Server-side encryption)
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
