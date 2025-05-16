output "user_pool_id" {
  description = "AWS Cognito User Pool ID"
  value       = aws_cognito_user_pool.jobtracker_user_pool.id
}

output "cognito_user_pool_client_id" {
  value       = aws_cognito_user_pool_client.jobtracker_user_pool_client.id
  description = "The Cognito user pool client ID"
}

output "cognito_user_pool_endpoint" {
  value       = aws_cognito_user_pool.jobtracker_user_pool.endpoint
  description = "The Cognito user pool endpoint"
}

output "cognito_login_url" {
  value = "https://${aws_cognito_user_pool_domain.jobtracker_domain.domain}.auth.${var.aws_region}.amazoncognito.com/login?response_type=token&client_id=${aws_cognito_user_pool_client.jobtracker_user_pool_client.id}&redirect_uri=http://localhost:3000"
}

output "cognito_issuer" {
  description = "JWT issuer URL for Cognito"
  value       = "https://${aws_cognito_user_pool_domain.jobtracker_domain.domain}.auth.${var.aws_region}.amazoncognito.com"
}