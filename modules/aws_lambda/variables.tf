variable "env" {
  description = "Environment name dev/prd"
  type = string
}

variable "lambda_name" {
  description = "Name of the lambda function"
  type = string
}

variable "lambda_path" {
  description = "Path where the lambda code is"
  type = string
}

variable "lambda_runtime" {
  description = "Language used by the lambda function"
  type = string
  default = "python3.9"
}

variable "root_path" {
  description = "Path where the lambda code is"
  type = string
}

variable "memory_size" {
  description = "Memory size (MB) for the Lambda function"
  type = string
}

variable "timeout" {
  description = "Number of seconds after which the lambda times out"
  type = number
}

variable "log_retention_days" {
  description = "Number of days to retain the logs in cloudwatch"
  type = number
}

variable "env_vars" {
  description = "Environment variables to be passed to the Lambda function"
  type = map(string)
}

variable "iam_role_name" {
  description = "Name for the iam_role"
  type = string
}

variable "iam_logging_policy_name" {
  description = "Name for the iam policy for cloudwatch logs"
  type = string
}

variable "sns_alert_enabled" {
  description = "Enable policy to send messages to SNS"
  type = number
  default = 0
}

variable "iam_alerting_policy_name" {
  description = "Name for the iam policy for sns topic"
  type = string
  default = ""
}

variable "sns_topic_name" {
  description = "Name for topic name"
  type = string
  default = ""
}

variable "tags" {
  description = "Tags used by Terraform"
  type = map(string)
}

variable "s3_policy_enabled" {
  description = "Enable policy to access S3"
  type = number
  default = 0
}

variable "bucket_id" {
  description = "Name of the bucket for the policy"
  type = string
  default = ""
}

variable "iam_s3_policy_name" {
  description = "Name of the policy for S3"
  type = string
  default = "remove-me"
}

variable "iam_s3_actions" {
  description = "Actions for the IAM policy to access S3"
  type = list(string)
  default = ["s3:ListBucket"]
}
