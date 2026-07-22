variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev1"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "aws_region" {
  description = "AWS region for the workload."
  type        = string
  default     = "us-west-2"
}

variable "enable_deletion_protection" {
  description = "Protect stateful resources from accidental deletion in production-like environments."
  type        = bool
  default     = false
}

variable "db_billing_mode" {
  description = "DynamoDB billing mode. PAY_PER_REQUEST is recommended for variable traffic."
  type        = string
  default     = "PAY_PER_REQUEST"

  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.db_billing_mode)
    error_message = "db_billing_mode must be PAY_PER_REQUEST or PROVISIONED."
  }
}

variable "enable_point_in_time_recovery" {
  description = "Enable DynamoDB point-in-time recovery for stronger data protection."
  type        = bool
  default     = true
}

variable "frontend_cdn_price_class" {
  description = "CloudFront price class for frontend distribution."
  type        = string
  default     = "PriceClass_100"

  validation {
    condition     = contains(["PriceClass_100", "PriceClass_200", "PriceClass_All"], var.frontend_cdn_price_class)
    error_message = "frontend_cdn_price_class must be PriceClass_100, PriceClass_200, or PriceClass_All."
  }
}

variable "lambda_runtime" {
  description = "Node.js runtime for Lambda functions."
  type        = string
  default     = "nodejs20.x"
}

variable "lambda_memory_size" {
  description = "Lambda memory in MB."
  type        = number
  default     = 256

  validation {
    condition     = var.lambda_memory_size >= 128 && var.lambda_memory_size <= 10240
    error_message = "lambda_memory_size must be between 128 and 10240."
  }
}

variable "lambda_timeout" {
  description = "Lambda timeout in seconds."
  type        = number
  default     = 10

  validation {
    condition     = var.lambda_timeout >= 1 && var.lambda_timeout <= 900
    error_message = "lambda_timeout must be between 1 and 900."
  }
}

variable "log_retention_days" {
  description = "CloudWatch log retention for Lambda functions."
  type        = number
  default     = 14
}

variable "cors_allow_origin" {
  description = "Allowed CORS origin for API responses. Use a specific frontend URL in production."
  type        = string
  default     = "*"
}

variable "alarm_sns_topic_arn" {
  description = "Optional SNS topic ARN for CloudWatch alarm notifications. Leave empty to disable alarm actions."
  type        = string
  default     = ""
}
