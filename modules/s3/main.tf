# --- modules/s3/main.tf ---

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Tạo S3 Bucket để lưu trữ hồ sơ bệnh án, hình ảnh X-quang
resource "aws_s3_bucket" "clinic_data" {
  bucket = "clinic-data-${var.environment}-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "Clinic Data Bucket"
    Environment = var.environment
  }
}

# Bật tính năng Versioning (Lưu lịch sử thay đổi file)
# Quan trọng cho dữ liệu y tế để tránh xóa nhầm.
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.clinic_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Mã hóa dữ liệu (Server-side encryption)
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.clinic_data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
