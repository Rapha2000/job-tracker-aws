output "api_base_url" {
  description = "Base URL for API Gateway stage."

  value = module.backend.api_base_url
}

output "cognito_login_url" {
  value = module.backend.cognito_login_url
}

output "user_pool_id" {
  description = "AWS Cognito User Pool ID"
  value       = module.backend.user_pool_id
}

output "cognito_issuer" {
  description = "JWT issuer URL for Cognito"
  value       = module.backend.cognito_issuer
}

output "cognito_client_id" {
  description = "AWS Cognito Client ID"
  value       = module.backend.cognito_client_id
}