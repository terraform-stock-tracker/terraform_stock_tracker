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

variable "tags" {
  description = "Tags used by Terraform"
  type = map(string)
}