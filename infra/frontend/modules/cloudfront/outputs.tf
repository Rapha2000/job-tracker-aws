output "cloudfront_distribution_domain" {
  description = "CloudFront distribution domain name."
  value       = aws_cloudfront_distribution.job-tracker-website-cloudfront-distribution.domain_name
}