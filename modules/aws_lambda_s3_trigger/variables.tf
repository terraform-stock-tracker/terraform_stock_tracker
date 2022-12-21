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

variable "bucket_name" {
  description   = "Bucket name"
  type          = string
}

variable "bucket_id" {
  description   = "Bucket id"
  type          = string
}

variable "filter_prefix" {
  description   = "Prefix to filter on"
  type          = string
}

variable "filter_suffix" {
  description   = "Suffix to filter on"
  type          = string
}


