
resource "aws_s3_bucket" "s3_bucket" {
  bucket    = var.bucket_name
  tags      = var.tags
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket    = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = var.bucket_versioning
  }
}