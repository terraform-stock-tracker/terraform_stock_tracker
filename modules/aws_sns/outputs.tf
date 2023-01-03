output "sns_topic_id" {
  description = "SNS topic id"
  value = aws_sns_topic.aws_sns_topic.*.id
}

output "sns_topic_arn" {
  description = "SNS topic ARN"
  value = aws_sns_topic.aws_sns_topic.*.arn
}

output "sns_email_subscription_arn" {
  description = "SNS subscription ARN"
  value = aws_sns_topic_subscription.aws_sns_email.*.arn
}