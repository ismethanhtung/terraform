# --- modules/s3/outputs.tf ---

output "bucket_name" {
  description = "Tên của S3 Bucket"
  value       = aws_s3_bucket.data.bucket
}

output "bucket_arn" {
  description = "ARN của S3 Bucket"
  value       = aws_s3_bucket.data.arn
}
