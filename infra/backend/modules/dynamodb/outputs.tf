output "dynamodb_access_policy_arn" {
  value       = aws_iam_policy.dynamodb_access_policy.arn
  description = "aws IAM policy ARN for the DynamoDB access"
}