variable "name_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "cdn_price_class" {
  type    = string
  default = "PriceClass_100"
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}

variable "default_root_object" {
  type    = string
  default = "index.html"
}

variable "cdn_allowed_methods" {
  type    = list(string)
  default = ["GET", "HEAD", "OPTIONS"]
}

variable "cdn_cached_methods" {
  type    = list(string)
  default = ["GET", "HEAD"]
}
