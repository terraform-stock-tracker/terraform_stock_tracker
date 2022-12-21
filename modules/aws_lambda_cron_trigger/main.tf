#################################################################
######### Lambda CRON Trigger ###################################
#################################################################
resource "aws_cloudwatch_event_rule" "cron_event_rule" {
  count               = var.lambda_cron_count
  name                = format("%s-%s", var.lambda_name, lower(var.lambda_cron_input[count.index]["ticker"]))
  schedule_expression = var.lambda_cron_schedule
  tags                = var.tags
  is_enabled          = true
}

resource "aws_cloudwatch_event_target" "lambda_event_target" {
  count               = var.lambda_cron_count
  rule                = aws_cloudwatch_event_rule.cron_event_rule[count.index].name
  target_id           = var.lambda_name
  arn                 = var.lambda_arn
  input               = jsonencode(var.lambda_cron_input[count.index])
  depends_on          = [aws_cloudwatch_event_rule.cron_event_rule]
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
  count               = var.lambda_cron_count
  statement_id        = format("%s-%s", "AllowExecutionFromCloudWatch", lower(var.lambda_cron_input[count.index]["ticker"])) # This needs to be unique
  action              = "lambda:InvokeFunction"
  function_name       = var.lambda_name
  principal           = "events.amazonaws.com"
  source_arn          = aws_cloudwatch_event_rule.cron_event_rule[count.index].arn
  depends_on          = [aws_cloudwatch_event_rule.cron_event_rule, aws_cloudwatch_event_target.lambda_event_target]
}