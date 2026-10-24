output "frontend_url" {
  description = "CloudFront URL for the React frontend."
  value       = "https://${module.frontend.cdn_domain_name}"
}

output "backend_url" {
  description = "API Gateway URL for the Todo backend."
  value       = module.backend.api_gateway_url
}

output "frontend_bucket" {
  description = "S3 bucket used for frontend hosting."
  value       = module.frontend.s3_bucket_id
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID for cache invalidation."
  value       = module.frontend.cdn_distribution_id
}
