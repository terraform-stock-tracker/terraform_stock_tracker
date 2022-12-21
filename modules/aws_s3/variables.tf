variable "env" {
  description = "Environment"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "tags" {
  description = "Tags for the resource"
  type = map(string)
}

variable "bucket_versioning" {
  description = "Flag to enable / disable bucket versioning"
  type = string
  default = "Disabled"
}