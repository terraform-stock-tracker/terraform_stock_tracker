#################################################################
######### S3 ####################################################
#################################################################
module "s3_raw" {
  source                  = "./modules/aws_s3"
  bucket_name             = var.s3_raw_bucket_name
  env                     = var.env
  bucket_versioning       = var.s3_raw_bucket_versioning
  tags                    = var.tags
}

module "s3_transform" {
  source                  = "./modules/aws_s3"
  bucket_name             = var.s3_transformed_bucket_name
  env                     = var.env
  bucket_versioning       = var.s3_transformed_bucket_versioning
  tags                    = var.tags
}


#################################################################
######### Lambdas ###############################################
#################################################################

# 1. Scraper Lambda with CRON trigger
module "scraper_lambda" {
  source                  = "./modules/aws_lambda"
  env                     = var.env
  lambda_name             = var.scraper_lambda_name
  lambda_path             = var.scraper_lambda_path
  log_retention_days      = var.scraper_lambda_log_retention
  memory_size             = var.scraper_lambda_memory_size
  lambda_runtime          = var.scraper_lambda_runtime
  root_path               = var.scraper_lambda_root_path
  timeout                 = var.scraper_lambda_timeout
  env_vars                = var.scraper_lambda_env_vars
  tags                    = var.tags
}

module "scraper_lambda_trigger" {
  source                  = "./modules/aws_lambda_cron_trigger"
  env                     = var.env
  lambda_name             = module.scraper_lambda.function_name
  lambda_arn              = module.scraper_lambda.function_arn
  lambda_cron_count       = var.scraper_lambda_trigger_count
  lambda_cron_input       = var.scraper_lambda_trigger_events
  lambda_cron_schedule    = var.scraper_lambda_trigger_cron
  tags                    = var.tags
}


# 2. Transformer Lambda with S3 bucket trigger
module "transformer_lambda" {
  source                  = "./modules/aws_lambda"
  env                     = var.env
  lambda_name             = var.transform_lambda_name
  lambda_path             = var.transform_lambda_path
  log_retention_days      = var.transform_lambda_log_retention
  memory_size             = var.transform_lambda_log_retention
  lambda_runtime          = var.transform_lambda_runtime
  root_path               = var.transform_lambda_root_path
  timeout                 = var.transform_lambda_timeout
  env_vars                = var.transform_lambda_env_vars
  tags                    = var.tags
}

module "transformer_lambda_trigger" {
  source                  = "./modules/aws_lambda_s3_trigger"
  bucket_id               = module.s3_transform.s3_bucket_id
  bucket_name             = var.s3_transformed_bucket_name
  env                     = var.env
  filter_prefix           = var.transform_lambda_trigger_prefix
  filter_suffix           = var.transform_lambda_trigger_suffix
  lambda_arn              = module.transformer_lambda.function_arn
  lambda_name             = module.transformer_lambda.function_name
}



