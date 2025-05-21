# resource "aws_cloudfront_origin_access_identity" "job-tracker-website-cloudfront-origin-access-identity" {
#   comment = "Job Tracker Website CloudFront Origin Access Identity"
# }

# CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "cloudfront_oac" {
  name                              = "example-oac"
  description                       = "Example Origin Access Control for S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# data "aws_iam_policy_document" "job-tracker-website-cloudfront-origin-access-identity-policy" {
#   statement {
#     actions   = ["s3:GetObject"]
#     resources = ["${var.job-tracker-website-bucket-arn}/*"]
#     principals {
#       type        = "AWS"
#       identifiers = [aws_cloudfront_origin_access_identity.job-tracker-website-cloudfront-origin-access-identity.iam_arn]
#     }
#   }
# }

resource "aws_s3_bucket_policy" "job-tracker-website-bucket-policy" {
  bucket = var.job-tracker-website-bucket-id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowCloudFrontServicePrincipalReadOnly",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : "s3:GetObject",
        "Resource" : "${var.job-tracker-website-bucket-arn}/*",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceArn" : "${aws_cloudfront_distribution.job-tracker-website-cloudfront-distribution.arn}"
          }
        }
      }
    ]
  })
}

resource "aws_cloudfront_distribution" "job-tracker-website-cloudfront-distribution" {
  enabled = true

  origin {
    domain_name              = var.job-tracker-website-bucket-regional-domain-name
    origin_id                = "origin-bucket-${var.job-tracker-website-bucket-id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_oac.id
  }

  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "origin-bucket-${var.job-tracker-website-bucket-id}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["FR"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  custom_error_response {
    error_code            = 403
    response_page_path    = "/index.html"
    response_code         = 200
    error_caching_min_ttl = 0
  }

  custom_error_response {
    error_code            = 404
    response_page_path    = "/index.html"
    response_code         = 200
    error_caching_min_ttl = 0
  }

  tags = {
    Environment = "dev"
  }
}

# resource "null_resource" "invalidate_html" {
#   triggers = {
#     index_file_hash = filemd5("${var.frontend_react_files_directory}/index.html")
#   }

#   provisioner "local-exec" {
#     command = "aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.job-tracker-website-cloudfront-distribution.id} --paths /index.html"

#     environment = {
#       AWS_ACCESS_KEY_ID     = var.aws_access_key_id
#       AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
#       AWS_DEFAULT_REGION    = var.aws_region
#     }
#   }

#   depends_on = [aws_cloudfront_distribution.jokes_website_distribution]
# }