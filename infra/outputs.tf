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
