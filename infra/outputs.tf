# Output value definitions

output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."

  value = aws_s3_bucket.lambda_create_bucket.id
}

output "create_function_name" {
  description = "Name of the 'createApplication' Lambda function."

  value = aws_lambda_function.createApplication.function_name
}