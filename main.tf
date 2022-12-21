module "lambda_function" {
  source                  = "modulesws_lambda"
  env                     = "dev"
  lambda_name             = "dev-test-lambda"
  lambda_path             = "lambda"
  log_retention_days      = 1
  memory_size             = "128"
  lambda_runtime          = "python3.9"
  root_path               = "."
  tags                    = {}
  timeout                 = 3
  env_vars                = {
                              "env": "dev"
                            }
}

module "lambda_cron_trigger" {
  source                  = "modulesws_lambda_cron_trigger"
  env                     = "dev"
  lambda_name             = module.lambda_function.function_name
  lambda_arn              = module.lambda_function.function_arn
  lambda_cron_count       = 1
  lambda_cron_input       = [{"ticker": "NVDA"}]
  lambda_cron_schedule    = "cron(0 * * * ? *)"
  tags                    = {}
}

module "s3_raw" {
  source                  = "modulesws_s3"
  bucket_name             = "test-bucket"
  env                     = "dev"
  tags                    = {}
}

module "s3_transform" {
  source                  = "modulesws_s3"
  bucket_name             = "test-bucket-transform"
  env                     = "dev"
  tags                    = {}
}
