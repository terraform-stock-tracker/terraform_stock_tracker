env = "dev"


tags = {
  Environment: "dev"
  Project: "terraform-stock-tracker"
  ProjectCode: 3
  Provisioner: "Terraform"
}


s3 = {
  raw = {
    bucket_name             = "dev-stock-tracker-raw"
    versioning              = "Disabled"
  }
  transform = {
    bucket_name             = "dev-stock-tracker-transformed"
    versioning              = "Disabled"
  }
}


sns = {
  count                     = 1
  topic_name                = "dev-stock-tracker"
  subscription_count        = 1
  subscription_email        = "gabriel.oana91@gmail.com"
}


lambda = {
  scraper = {
    name                    = "dev-stock-tracker-scraper"
    path                    = "lambda/scraper"
    log_retention           = 3
    root_path               = "lambda"
    memory_size             = "128"
    runtime                 = "python3.9"
    timeout                 = 10
    env_vars                = { env : "dev" }
    sns_alert_enabled       = 1
    iam                     = {
      role_name                 = "dev-stock-tracker-scraper-iam-role"
      logging_policy_name       = "dev-stock-tracker-scraper-iam-logging-policy"
      alerting_policy_name      = "dev-stock-tracker-scraper-iam-alerting-policy"
      s3                        = {
        role_name                 = "dev-stock-tracker-scraper-iam-s3-policy"
        actions                   = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
        bucket_name               = "dev-stock-tracker-raw"
      }
    }
    trigger = {
      cron = {
        count                   = 1
        events                  = [{ticker: "VUSA", dry_run: false, bucket_name: "dev-stock-tracker-raw"}]
        schedule                = "cron(0 * * * ? *)"
      }
    }
  }

  transform = {
    name                    = "dev-stock-tracker-transform"
    path                    = "lambda/scraper"
    log_retention           = 3
    memory_size             = "128"
    runtime                 = "python3.9"
    root_path               = "lambda"
    timeout                 = 3
    env_vars                = { env : "dev" }
    sns_alert_enabled       = 1
    iam                     = {
      role_name                 = "dev-stock-tracker-transform-iam-role"
      logging_policy_name       = "dev-stock-tracker-transform-iam-logging-policy"
      alerting_policy_name      = "dev-stock-tracker-transform-iam-alerting-policy"
    }
    trigger = {
      s3 = {
        filter_prefix           = ""
        filter_suffix           = ""
      }
    }
  }

}
