variable "env" {
  description   = "Environment name dev/prd"
  type          = string
}

variable "lambda_name" {
  description   = "Name of the lambda function"
  type          = string
}

variable "lambda_arn" {
  description   = "ARN of the lambda function"
  type          = string
}

variable "lambda_cron_schedule" {
  description   = "Cron schedule for the lambda to trigger"
  type          = string
}

variable "lambda_cron_count" {
  description   = "Flag to enable/disable the event rule from cron"
  type          = number
}

variable "lambda_cron_input" {
  description   = "JSON input to be passed to the lambda function via the trigger"
  type          = list(map(string))
}

variable "tags" {
  description = "Tags used by Terraform"
  type = map(string)
}
