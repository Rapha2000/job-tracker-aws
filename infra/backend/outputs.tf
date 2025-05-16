# Output value definitions

output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."

  value = module.lambdas.lambda_bucket_name
}

output "create_function_name" {
  description = "Name of the 'createApplication' Lambda function."

  value = module.lambdas.createApplication_lambda_function_name
}

output "delete_function_name" {
  description = "Name of the 'deleteApplication' Lambda function."

  value = module.lambdas.deleteApplication_lambda_function_name
}

output "get_function_name" {
  description = "Name of the 'getApplications' Lambda function."

  value = module.lambdas.getApplication_lambda_function_name
}

output "update_function_name" {
  description = "Name of the 'updateApplication' Lambda function."

  value = module.lambdas.updateApplication_lambda_function_name
}

output "api_base_url" {
  description = "Base URL for API Gateway stage."

  value = module.api_gateway.api_base_url
}

output "cognito_login_url" {
  description = "URL for Cognito login page."

  value = module.cognito.cognito_login_url
}

output "user_pool_id" {
  description = "AWS Cognito User Pool ID"
  value       = module.cognito.user_pool_id
}

output "cognito_issuer" {
  description = "JWT issuer URL for Cognito"
  value       = module.cognito.cognito_issuer
}

output "cognito_client_id" {
  description = "AWS Cognito Client ID"
  value       = module.cognito.cognito_user_pool_client_id
}
