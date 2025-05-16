variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "eu-west-3"
}

variable "dynamodb_access_policy_arn" {
  type = string
  description = "aws IAM policy ARN for the DynamoDB access"
}