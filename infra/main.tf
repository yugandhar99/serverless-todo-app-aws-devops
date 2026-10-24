module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "5.1.0"

  name         = "${local.project_name}-${var.environment}-dynamodb"
  hash_key     = "id"
  billing_mode = var.db_billing_mode

  point_in_time_recovery_enabled = var.enable_point_in_time_recovery
  deletion_protection_enabled    = var.enable_deletion_protection
  server_side_encryption_enabled = true

  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]
}

module "backend" {
  source = "./modules/backend"

  name_prefix       = local.project_name
  environment       = var.environment
  requirements_path = "${local.backend_root}/package.json"
  handlers_dir      = "${local.backend_root}/functions"
  handler_extension = "mjs"
  runtime           = var.lambda_runtime
  memory_size       = var.lambda_memory_size
  timeout           = var.lambda_timeout
  log_retention_days = var.log_retention_days
  cors_allow_origin  = var.cors_allow_origin
  alarm_sns_topic_arn = var.alarm_sns_topic_arn

  routes = {
    "GET /todos"         = "list"
    "POST /todos"        = "create"
    "GET /todos/{id}"    = "get"
    "PUT /todos/{id}"    = "update"
    "DELETE /todos/{id}" = "delete"
  }

  dynamodb_table_id  = module.dynamodb_table.dynamodb_table_id
  dynamodb_table_arn = module.dynamodb_table.dynamodb_table_arn

  enable_deletion_protection = var.enable_deletion_protection
}

module "frontend" {
  source = "./modules/frontend"

  name_prefix                = local.project_name
  environment                = var.environment
  cdn_price_class            = var.frontend_cdn_price_class
  enable_deletion_protection = var.enable_deletion_protection
}
