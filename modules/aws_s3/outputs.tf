output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value = aws_s3_bucket.s3_bucket.arn
}