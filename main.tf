#################################################################
######### S3 ####################################################
#################################################################
module "s3_raw" {
  source                  = "./modules/aws_s3"
  bucket_name             = var.s3.raw.bucket_name
  env                     = var.env
  bucket_versioning       = var.s3.raw.versioning
  tags                    = var.tags
}

module "s3_transform" {
  source                  = "./modules/aws_s3"
  bucket_name             = var.s3.transform.bucket_name
  env                     = var.env
  bucket_versioning       = var.s3.transform.versioning
  tags                    = var.tags
}

#################################################################
######### SNS ###################################################
#################################################################
module "sns" {
  source                    = "./modules/aws_sns"
  topic_count               = var.sns.count
  topic_name                = var.sns.topic_name
  email                     = var.sns.subscription_email
  email_subscription_count  = var.sns.subscription_count
  tags                      = var.tags
}


#################################################################
######### Lambdas ###############################################
#################################################################

# 1. Scraper Lambda with CRON trigger
module "scraper_lambda" {
  source                    = "./modules/aws_lambda"
  env                       = var.env
  lambda_name               = var.lambda.scraper.name
  lambda_path               = var.lambda.scraper.path
  log_retention_days        = var.lambda.scraper.log_retention
  memory_size               = var.lambda.scraper.memory_size
  lambda_runtime            = var.lambda.scraper.runtime
  root_path                 = var.lambda.scraper.root_path
  timeout                   = var.lambda.scraper.timeout
  env_vars                  = var.lambda.scraper.env_vars
  iam_logging_policy_name   = var.lambda.scraper.iam.logging_policy_name
  iam_alerting_policy_name  = var.lambda.scraper.iam.alerting_policy_name
  iam_role_name             = var.lambda.scraper.iam.role_name
  s3_policy_enabled         = var.lambda.scraper.iam.s3 == null ? 0 : 1
  iam_s3_policy_name        = var.lambda.scraper.iam.s3.role_name
  bucket_id                 = var.lambda.scraper.iam.s3.bucket_name
  iam_s3_actions            = var.lambda.scraper.iam.s3.actions
  sns_alert_enabled         = var.lambda.scraper.sns_alert_enabled
  sns_topic_name            = var.sns.topic_name
  tags                      = var.tags
}

module "scraper_lambda_trigger" {
  source                    = "./modules/aws_lambda_cron_trigger"
  env                       = var.env
  lambda_name               = module.scraper_lambda.function_name
  lambda_arn                = module.scraper_lambda.function_arn
  lambda_cron_count         = var.lambda.scraper.trigger.cron.count
  lambda_cron_input         = var.lambda.scraper.trigger.cron.events
  lambda_cron_schedule      = var.lambda.scraper.trigger.cron.schedule
  tags                      = var.tags
}

# 2. Transformer Lambda with S3 bucket trigger
module "transformer_lambda" {
  source                    = "./modules/aws_lambda"
  env                       = var.env
  lambda_name               = var.lambda.transform.name
  lambda_path               = var.lambda.transform.path
  log_retention_days        = var.lambda.transform.log_retention
  memory_size               = var.lambda.transform.memory_size
  lambda_runtime            = var.lambda.transform.runtime
  root_path                 = var.lambda.transform.root_path
  timeout                   = var.lambda.transform.timeout
  env_vars                  = var.lambda.transform.env_vars
  iam_logging_policy_name   = var.lambda.transform.iam.logging_policy_name
  iam_alerting_policy_name  = var.lambda.transform.iam.alerting_policy_name
  iam_role_name             = var.lambda.transform.iam.role_name
  s3_policy_enabled         = var.lambda.scraper.iam.s3 == null ? 0 : 1
  sns_alert_enabled         = var.lambda.transform.sns_alert_enabled
  sns_topic_name            = var.sns.topic_name
  tags                      = var.tags
}

module "transformer_lambda_trigger" {
  source                    = "./modules/aws_lambda_s3_trigger"
  bucket_id                 = module.s3_transform.s3_bucket_id
  bucket_name               = var.s3.transform.bucket_name
  env                       = var.env
  filter_prefix             = var.lambda.transform.trigger.s3.filter_prefix
  filter_suffix             = var.lambda.transform.trigger.s3.filter_suffix
  lambda_arn                = module.transformer_lambda.function_arn
  lambda_name               = module.transformer_lambda.function_name
}
