output "job-tracker-website-bucket-arn" {
  value       = aws_s3_bucket.job-tracker-website-bucket.arn
  description = "value of the job-tracker-website-bucket ARN"
}

output "job-tracker-website-bucket-id" {
  value       = aws_s3_bucket.job-tracker-website-bucket.id
  description = "value of the job-tracker-website-bucket ID"
}

output "job-tracker-website-bucket-regional-domain-name" {
  value       = aws_s3_bucket.job-tracker-website-bucket.bucket_regional_domain_name
  description = "value of the job-tracker-website-bucket regional domain name"
}

output "job_tracker_website_bucket_url" {
  description = "URL of the S3 bucket hosting the React frontend."
  value       = "http://${aws_s3_bucket.job-tracker-website-bucket.bucket}.s3-website.${var.aws_region}.amazonaws.com"
}