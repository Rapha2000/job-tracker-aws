output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."

  value = aws_s3_bucket.lambdas_bucket.id
}

output "createApplication_lambda_integration_invoke_arn" {
  value       = aws_lambda_function.createApplication.invoke_arn
  description = "The invoke ARN of the createApplication lambda function"
}

output "createApplication_lambda_function_name" {
  value       = aws_lambda_function.createApplication.function_name
  description = "The name of the createApplication lambda function"
}

output "deleteApplication_lambda_integration_invoke_arn" {
  value       = aws_lambda_function.deleteApplication.invoke_arn
  description = "The invoke ARN of the deleteApplication lambda function"
}

output "deleteApplication_lambda_function_name" {
  value       = aws_lambda_function.deleteApplication.function_name
  description = "The name of the deleteApplication lambda function"
}

output "getApplication_lambda_integration_invoke_arn" {
  value       = aws_lambda_function.getApplications.invoke_arn
  description = "The invoke ARN of the getApplication lambda function"
}

output "getApplication_lambda_function_name" {
  value       = aws_lambda_function.getApplications.function_name
  description = "The name of the getApplication lambda function"
}

output "updateApplication_lambda_integration_invoke_arn" {
  value       = aws_lambda_function.updateApplication.invoke_arn
  description = "The invoke ARN of the updateApplication lambda function"
}

output "updateApplication_lambda_function_name" {
  value       = aws_lambda_function.updateApplication.function_name
  description = "The name of the updateApplication lambda function"
}