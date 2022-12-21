env = "dev"

# Lambda
lambda_name = "dev-stock-tracker-scraper"
lambda_path = "lambda"
root_path = "."
memory_size = 128 # MB
timeout = 3 # seconds
log_retention_days = 3
lambda_cron_schedule = "cron(0 * * * ? *)"
lambda_cron_count = 2
lambda_cron_input = [
  {
    ticker: "VUSA"
  },
  {
    ticker: "NVDA"
  }
]
env_vars = {
  env: "dev"
}


# Tags
tags = {
  Environment: "dev"
  Project: "terraform-stock-tracker"
  ProjectCode: 3
  Provisioner: "Terraform"
}

