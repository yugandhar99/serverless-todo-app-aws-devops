environment                   = "prod"
aws_region                    = "us-west-2"
enable_deletion_protection    = true
db_billing_mode               = "PAY_PER_REQUEST"
enable_point_in_time_recovery = true
frontend_cdn_price_class      = "PriceClass_100"
lambda_runtime                = "nodejs20.x"
lambda_memory_size            = 256
lambda_timeout                = 10
log_retention_days            = 30
# Replace * with your CloudFront URL or custom domain after deployment.
cors_allow_origin             = "*"
alarm_sns_topic_arn           = ""
