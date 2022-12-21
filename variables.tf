variable "env" {
  description = "Environment name dev/prd"
  type = string
}

variable s3_raw_bucket_name {
  description = "Name of the raw S3 bucket"
  type = string
}

variable s3_raw_bucket_versioning {
  description = "Bucket versioning flag for S3"
  type = string
}

variable s3_transformed_bucket_name {
  description = "Name of the transformed S3 bucket"
  type = string
}

variable s3_transformed_bucket_versioning {
  description = "Bucket versioning flag for S3"
  type = string
}

variable scraper_lambda_name {
  description = "Name of scraper lambda function"
  type = string
}

variable scraper_lambda_path {
  description = "Path of the lambda scraper"
  type = string
}

variable scraper_lambda_root_path {
  description = "Path of where all the lambda code is stored"
  type = string
}

variable scraper_lambda_runtime {
  description = "Language used for the lambda function"
  type = string
}

variable scraper_lambda_memory_size {
  description = "Lambda memory size"
  type = number
}

variable scraper_lambda_timeout {
  description = "Lambda timeout in seconds"
  type = number
}

variable scraper_lambda_log_retention {
  description = "Lambda log retention in days"
  type = number
}

variable scraper_lambda_env_vars {
  description = "Lambda environment variables"
  type = map(string)
}

variable scraper_lambda_trigger_cron {
  description = "Lambda cron trigger"
  type = string
}

variable scraper_lambda_trigger_count {
  description = "Number of triggers - this needs to be equal to the elements in the trigger events"
  type = number
}

variable scraper_lambda_trigger_events {
  description = "Events on lambda trigger"
  type = list(map(string))
}

variable tags {
  description = "Events on lambda trigger"
  type = map(string)
}

