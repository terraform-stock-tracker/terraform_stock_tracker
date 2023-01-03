variable "topic_count" {
  description = "Counter for the topic"
  type = number
}

variable "topic_name" {
  description = "Name for the SNS Topic"
  type = string
}

variable "email_subscription_count" {
  description = "Counter for the email subscriptions"
  type = number
}

variable "email" {
  description = "Email to which the SNS will send messages"
  type = string
}

variable tags {
  description = "Events on lambda trigger"
  type = map(string)
}
