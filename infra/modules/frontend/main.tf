locals {
  bucket_name = "${var.name_prefix}-fe-s3-${var.environment}"
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.5.0"

  bucket = local.bucket_name

  attach_policy = false

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  force_destroy = !var.enable_deletion_protection
}

resource "aws_cloudfront_response_headers_policy" "security_headers" {
  name    = "${var.name_prefix}-${var.environment}-security-headers"
  comment = "Security headers for ${var.name_prefix} ${var.environment} frontend"

  security_headers_config {
    content_type_options {
      override = true
    }

    frame_options {
      frame_option = "DENY"
      override     = true
    }

    referrer_policy {
      referrer_policy = "strict-origin-when-cross-origin"
      override        = true
    }

    strict_transport_security {
      access_control_max_age_sec = 31536000
      include_subdomains         = true
      preload                    = true
      override                   = true
    }

    xss_protection {
      mode_block = true
      protection = true
      override   = true
    }
  }
}

module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  comment             = "CloudFront for ${module.s3_bucket.s3_bucket_id} bucket"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = var.cdn_price_class
  retain_on_delete    = var.enable_deletion_protection
  default_root_object = var.default_root_object

  create_origin_access_control = true
  origin_access_control = {
    s3_oac = {
      description      = "CloudFront access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  origin = {
    s3 = {
      domain_name           = module.s3_bucket.s3_bucket_bucket_regional_domain_name
      origin_access_control = "s3_oac"
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = var.cdn_allowed_methods
    cached_methods  = var.cdn_cached_methods

    use_forwarded_values = false

    cache_policy_name          = "Managed-CachingOptimized"
    origin_request_policy_name = "Managed-CORS-S3Origin"
    response_headers_policy_id = aws_cloudfront_response_headers_policy.security_headers.id
  }

  ordered_cache_behavior = [
    {
      target_origin_id       = "s3"
      path_pattern           = "/static/*"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = var.cdn_allowed_methods
      cached_methods  = var.cdn_cached_methods

      use_forwarded_values = false

      cache_policy_name          = "Managed-CachingOptimized"
      origin_request_policy_name = "Managed-CORS-S3Origin"
      response_headers_policy_id = aws_cloudfront_response_headers_policy.security_headers.id
    },
  ]

  viewer_certificate = {
    cloudfront_default_certificate = true
  }
}

resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = module.s3_bucket.s3_bucket_id
  policy = templatefile("${path.module}/templates/s3_bucket_policy.json", {
    bucket_id = module.s3_bucket.s3_bucket_id
    cf_arn    = module.cdn.cloudfront_distribution_arn
  })
}
