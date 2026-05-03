# Media bucket name
output "bucket_name" {
  value       = aws_s3_bucket.media_bucket.bucket
  description = "Media bucket name"
}

# Media bucket ID
output "bucket_id" {
  value       = aws_s3_bucket.media_bucket.id
  description = "Media bucket ID"
}

# Media bucket ARN
output "bucket_arn" {
  value       = aws_s3_bucket.media_bucket.arn
  description = "Media bucket ARN"
}