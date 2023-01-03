variable "env" {
  description = "Environment name dev/prd"
  type = string
}


variable s3 {
  type = object({
    raw = optional(object({
      bucket_name = string
      versioning = optional(string, "Disabled")
    }))
    transform = optional(object({
      bucket_name = string
      versioning = optional(string, "Disabled")
    }))
  })
}


variable sns {
  type = object({
    count = number
    topic_name = string
    subscription_count = optional(number, 0)
    subscription_email = optional(string)
  })
}


variable lambda {
  type = object({

    scraper = object({
      name          = string
      path          = string
      log_retention = number
      memory_size   = optional(string, "128")
      runtime       = optional(string, "python3.9")
      root_path     = string
      timeout       = number
      env_vars      = map(string)
      iam = object({
        role_name             = string
        logging_policy_name   = string
        alerting_policy_name  = string
      })
      sns_alert_enabled = optional(number, 0)
      trigger = object({
        cron = optional(object({
          count = optional(number, 0)
          events = optional(list(map(string)))
          schedule = optional(string)
        }))
        s3 = optional(object({
          filter_prefix = optional(string)
          filter_suffix = optional(string)
        }))
      })
    })

    transform = object({
      name          = string
      path          = string
      log_retention = number
      memory_size   = optional(string, "128")
      runtime       = optional(string, "python3.9")
      root_path     = string
      timeout       = number
      env_vars      = map(string)
      iam = object({
        role_name             = string
        logging_policy_name   = string
        alerting_policy_name  = string
      })
      sns_alert_enabled = optional(number, 0)
      trigger = object({
        cron = optional(object({
          count = optional(number, 0)
          events = optional(list(map(string)))
          schedule = optional(string)
        }))
        s3 = optional(object({
          filter_prefix = optional(string)
          filter_suffix = optional(string)
        }))
      })
    })

  })
}

variable tags {
  description = "Events on lambda trigger"
  type = map(string)
}