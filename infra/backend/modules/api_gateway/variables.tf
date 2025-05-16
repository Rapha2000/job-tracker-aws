variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "eu-west-3"
}

variable "createApplication_lambda_integration_invoke_arn" {
  type        = string
  description = "The invoke ARN of the createApplication lambda function"
}

variable "createApplication_lambda_function_name" {
  type        = string
  description = "The name of the createApplication lambda function"
}

variable "deleteApplication_lambda_integration_invoke_arn" {
  type        = string
  description = "The invoke ARN of the deleteApplication lambda function"
}

variable "deleteApplication_lambda_function_name" {
  type        = string
  description = "The name of the deleteApplication lambda function"
}

variable "getApplication_lambda_integration_invoke_arn" {
  type        = string
  description = "The invoke ARN of the getApplication lambda function"
}

variable "getApplication_lambda_function_name" {
  type        = string
  description = "The name of the getApplication lambda function"
}

variable "updateApplication_lambda_integration_invoke_arn" {
  type        = string
  description = "The invoke ARN of the updateApplication lambda function"
}

variable "updateApplication_lambda_function_name" {
  type        = string
  description = "The name of the updateApplication lambda function"
}

variable "cognito_user_pool_client_id" {
  type        = string
  description = "The Cognito user pool client ID"
}

variable "cognito_user_pool_endpoint" {
  type        = string
  description = "The Cognito user pool endpoint"
}