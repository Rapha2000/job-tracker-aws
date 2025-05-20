variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "eu-west-3"
}

variable "job-tracker-website-bucket-arn" {
  description = "S3 bucket arn for the job-tracker-website."
  type        = string
}

variable "job-tracker-website-bucket-id" {
  description = "S3 bucket id for the job-tracker-website."
  type        = string
}

variable "job-tracker-website-bucket-regional-domain-name" {
  description = "value of the job-tracker-website-bucket regional domain name"
  type        = string
}

variable "frontend_react_files_directory" {
  description = "Path to the React frontend source directory"
  type        = string
}