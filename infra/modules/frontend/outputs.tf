output "cdn_domain_name" {
  value = module.cdn.cloudfront_distribution_domain_name
}

output "cdn_hosted_zone_id" {
  value = module.cdn.cloudfront_distribution_hosted_zone_id
}

output "cdn_distribution_id" {
  value = module.cdn.cloudfront_distribution_id
}

output "s3_bucket_id" {
  value = module.s3_bucket.s3_bucket_id
}
