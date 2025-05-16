module "lambdas" {
  source = "./modules/lambdas"

  aws_region = var.aws_region

  dynamodb_access_policy_arn = module.dynamodb.dynamodb_access_policy_arn
}

module "dynamodb" {
  source = "./modules/dynamodb"

  aws_region = var.aws_region
}

module "cognito" {
  source = "./modules/cognito"

  aws_region = var.aws_region
}

module "api_gateway" {
  source = "./modules/api_gateway"

  aws_region = var.aws_region

  createApplication_lambda_integration_invoke_arn = module.lambdas.createApplication_lambda_integration_invoke_arn
  createApplication_lambda_function_name          = module.lambdas.createApplication_lambda_function_name

  deleteApplication_lambda_integration_invoke_arn = module.lambdas.deleteApplication_lambda_integration_invoke_arn
  deleteApplication_lambda_function_name          = module.lambdas.deleteApplication_lambda_function_name

  getApplication_lambda_integration_invoke_arn = module.lambdas.getApplication_lambda_integration_invoke_arn
  getApplication_lambda_function_name          = module.lambdas.getApplication_lambda_function_name

  updateApplication_lambda_integration_invoke_arn = module.lambdas.updateApplication_lambda_integration_invoke_arn
  updateApplication_lambda_function_name          = module.lambdas.updateApplication_lambda_function_name

  cognito_user_pool_client_id = module.cognito.cognito_user_pool_client_id
  cognito_user_pool_endpoint  = module.cognito.cognito_user_pool_endpoint
}