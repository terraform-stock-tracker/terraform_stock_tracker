env = "dev"

# S3
s3_raw_bucket_name                  = "dev-stock-tracker-raw"
s3_raw_bucket_versioning            = "Disabled"
s3_transformed_bucket_name          = "dev-stock-tracker-transformed"
s3_transformed_bucket_versioning    = "Disabled"


# Lambda
scraper_lambda_name                 = "dev-stock-tracker-scraper"
scraper_lambda_path                 = "scraper"
scraper_lambda_root_path            = "lambda"
scraper_lambda_runtime              = "python3.9"
scraper_lambda_memory_size          = 128
scraper_lambda_timeout              = 3
scraper_lambda_log_retention        = 3
scraper_lambda_env_vars             = {env: "dev"}
scraper_lambda_trigger_cron         = "cron(0 * * * ? *)"
scraper_lambda_trigger_count        = 2
scraper_lambda_trigger_events       = [{ticker: "VUSA"}, {ticker: "NVDA"}]



# Tags
tags = {
  Environment: "dev"
  Project: "terraform-stock-tracker"
  ProjectCode: 3
  Provisioner: "Terraform"
}

