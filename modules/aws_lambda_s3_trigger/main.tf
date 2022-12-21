#################################################################
######### Lambda S3 Trigger #####################################
#################################################################
resource "aws_s3_bucket_notification" "aws-lambda-s3-trigger" {
  bucket                  = var.bucket_name
  lambda_function {
    lambda_function_arn   = var.lambda_arn
    events                = ["s3:ObjectCreated:*"]
    filter_prefix         = var.filter_prefix
    filter_suffix         = var.filter_suffix
  }
}

resource "aws_lambda_permission" "aws_lambda_s3_trigger_permission" {
  statement_id            = "AllowS3Invoke"
  action                  = "lambda:InvokeFunction"
  function_name           = var.lambda_name
  principal               = "s3.amazonaws.com"
  source_arn              = "arn:aws:s3:::${var.bucket_id}"
}