variable "name_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "requirements_path" {
  type = string
}

variable "handlers_dir" {
  type = string
}

variable "handler_extension" {
  type    = string
  default = "js"
}

variable "handler_suffix" {
  type    = string
  default = "handler"
}

variable "routes" {
  type        = map(string)
  description = <<EOT
Map of API Gateway routes to Lambda handler file prefix.
Example:
{
  "GET /todos"      = "list"
  "POST /todos"     = "create"
  "GET /todos/{id}" = "get"
}
EOT
}

variable "runtime" {
  type    = string
  default = "nodejs20.x"
}

variable "memory_size" {
  type    = number
  default = 256
}

variable "timeout" {
  type    = number
  default = 10
}

variable "log_retention_days" {
  type    = number
  default = 14
}

variable "cors_allow_origin" {
  type    = string
  default = "*"
}

variable "dynamodb_table_id" {
  type = string
}

variable "dynamodb_table_arn" {
  type = string
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}

variable "alarm_sns_topic_arn" {
  type    = string
  default = ""
}
