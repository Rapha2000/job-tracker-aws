output "job_tracker_website_bucket_url" {
  description = "URL of the S3 bucket hosting the React frontend."
  value       = module.s3.job_tracker_website_bucket_url
}

output "cloudfront_distribution_domain" {
  description = "CloudFront distribution domain name."
  value       = module.cloudfront.cloudfront_distribution_domain
}