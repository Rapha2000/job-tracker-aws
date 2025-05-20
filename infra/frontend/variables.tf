variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "eu-west-3"
}

variable "cognito_user_pool_id" {
  description = "Cognito user pool id for the job-tracker-website."
  type        = string
}

variable "cognito_user_pool_client_id" {
  description = "Cognito user pool client id for the job-tracker-website."
  type        = string
}

variable "api_base_url" {
  description = "API base url for the job-tracker-website."
  type        = string
}


variable "frontend_source_directory" {
  description = "Path to the frontend source directory."
  type        = string
}