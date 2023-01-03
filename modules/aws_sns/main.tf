
resource "aws_sns_topic" "aws_sns_topic" {
  count = var.topic_count
  name = var.topic_name
  tags = var.tags
}

resource "aws_sns_topic_subscription" "aws_sns_email" {
  count     = var.email_subscription_count
  topic_arn = aws_sns_topic.aws_sns_topic[count.index].arn
  protocol  = "email"
  endpoint  = var.email
}