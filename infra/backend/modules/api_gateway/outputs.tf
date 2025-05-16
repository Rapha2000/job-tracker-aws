output "api_base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.lambda_stage.invoke_url
}