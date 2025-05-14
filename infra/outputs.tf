# Output value definitions

output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."

  value = aws_s3_bucket.lambdas_bucket.id
}

output "create_function_name" {
  description = "Name of the 'createApplication' Lambda function."

  value = aws_lambda_function.createApplication.function_name
}

output "delete_function_name" {
  description = "Name of the 'deleteApplication' Lambda function."

  value = aws_lambda_function.deleteApplication.function_name
}

output "get_function_name" {
  description = "Name of the 'getApplications' Lambda function."

  value = aws_lambda_function.getApplications.function_name
}

output "update_function_name" {
  description = "Name of the 'updateApplication' Lambda function."

  value = aws_lambda_function.updateApplication.function_name
}

output "api_base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.lambda_stage.invoke_url
}

output "cognito_login_url" {
  value = "https://${aws_cognito_user_pool_domain.jobtracker_domain.domain}.auth.${var.aws_region}.amazoncognito.com/login?response_type=token&client_id=${aws_cognito_user_pool_client.jobtracker_user_pool_client.id}&redirect_uri=http://localhost:3000"
}

output "user_pool_id" {
  description = "AWS Cognito User Pool ID"
  value       = aws_cognito_user_pool.jobtracker_user_pool.id
}

output "cognito_issuer" {
  description = "JWT issuer URL for Cognito"
  value       = "https://${aws_cognito_user_pool_domain.jobtracker_domain.domain}.auth.${var.aws_region}.amazoncognito.com"
}

output "cognito_client_id" {
  description = "AWS Cognito Client ID"
  value       = aws_cognito_user_pool_client.jobtracker_user_pool_client.id
}
