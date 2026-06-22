locals {
  normalized_routes = {
    for route, file_prefix in var.routes :
    route => {
      name         = "${var.name_prefix}-${var.environment}-${file_prefix}"
      method       = upper(split(" ", route)[0])
      path         = join(" ", slice(split(" ", route), 1, length(split(" ", route))))
      handler_file = "${file_prefix}.${var.handler_extension}"
      handler      = "${file_prefix}.${var.handler_suffix}"
    }
  }

  alarm_actions = var.alarm_sns_topic_arn == "" ? [] : [var.alarm_sns_topic_arn]
}

module "lambda_functions" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "8.1.0"

  for_each = local.normalized_routes

  function_name = each.value.name
  source_path = [
    "${var.handlers_dir}/${each.value.handler_file}",
    { npm_requirements = var.requirements_path }
  ]
  handler = each.value.handler
  runtime = var.runtime

  memory_size = var.memory_size
  timeout     = var.timeout
  publish     = true

  cloudwatch_logs_retention_in_days = var.log_retention_days
  tracing_mode                      = "Active"
  attach_tracing_policy             = true

  attach_policy_json = true
  policy_json = templatefile("${path.module}/templates/lambda_policy.json", {
    dynamodb_arn = var.dynamodb_table_arn
  })

  allowed_triggers = {
    apigw = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.api_execution_arn}/*/*"
    }
  }

  artifacts_dir = "${path.root}/.terraform/lambda-builds/"
  environment_variables = {
    ENVIRONMENT       = var.environment
    DYNAMODB_TABLE    = var.dynamodb_table_id
    CORS_ALLOW_ORIGIN = var.cors_allow_origin
    LOG_LEVEL         = var.environment == "prod" ? "INFO" : "DEBUG"
  }
}

module "api_gateway" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "5.3.1"

  name               = "${var.name_prefix}-${var.environment}-http"
  description        = "Serverless Todo backend HTTP API"
  protocol_type      = "HTTP"
  create_domain_name = false

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allow_origins = [var.cors_allow_origin]
    max_age       = 3600
  }

  routes = {
    for route, cfg in local.normalized_routes :
    "${cfg.method} ${cfg.path}" => {
      integration = {
        uri                    = module.lambda_functions[route].lambda_function_invoke_arn
        payload_format_version = "2.0"
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  for_each = local.normalized_routes

  alarm_name          = "${each.value.name}-errors"
  alarm_description   = "Alerts when Lambda ${each.value.name} records one or more errors in a 5-minute window."
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = local.alarm_actions
  ok_actions          = local.alarm_actions

  dimensions = {
    FunctionName = module.lambda_functions[each.key].lambda_function_name
  }
}
