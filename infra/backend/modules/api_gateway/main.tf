######################################################################################
######## 3. Creating the HTTP API Gateway that will be used to trigger the lambda functions
######################################################################################
resource "aws_apigatewayv2_api" "job_tracker_api" {
  name          = "job-tracker-api"
  protocol_type = "HTTP"
  description   = "API Gateway for the job tracker application"
  cors_configuration {
    allow_credentials = false
    allow_headers     = ["Content-Type", "Authorization"]
    allow_methods = ["OPTIONS", "GET", "POST", "PUT", "DELETE"]
    allow_origins = ["*"]
    expose_headers    = []
    max_age           = 3600
  }
}

resource "aws_cloudwatch_log_group" "log_group_api_gw" {
  name = "/aws/apigateway/job-tracker-api"

  retention_in_days = 7
}

resource "aws_apigatewayv2_stage" "lambda_stage" {
  api_id      = aws_apigatewayv2_api.job_tracker_api.id
  name        = "dev"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.log_group_api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

# createApplication route
resource "aws_apigatewayv2_integration" "createApplication_lambda_integration" {
  api_id = aws_apigatewayv2_api.job_tracker_api.id

  integration_uri    = var.createApplication_lambda_integration_invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "createApplication_lambda_route" {
  api_id = aws_apigatewayv2_api.job_tracker_api.id

  route_key = "POST /createApplication"
  target    = "integrations/${aws_apigatewayv2_integration.createApplication_lambda_integration.id}"

  # to enable Cognito auth: attach the authorizer to the route
  authorizer_id      = aws_apigatewayv2_authorizer.cognito_auth.id
  authorization_type = "JWT"
}

resource "aws_lambda_permission" "createApplication_api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.createApplication_lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.job_tracker_api.execution_arn}/*/*"
}

# deleteApplication route
resource "aws_apigatewayv2_integration" "deleteApplication_lambda_integration" {
  api_id = aws_apigatewayv2_api.job_tracker_api.id

  integration_uri    = var.deleteApplication_lambda_integration_invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "deleteApplication_lambda_route" {
  api_id = aws_apigatewayv2_api.job_tracker_api.id

  route_key = "POST /deleteApplication"
  target    = "integrations/${aws_apigatewayv2_integration.deleteApplication_lambda_integration.id}"

  # to enable Cognito auth: attach the authorizer to the route
  authorizer_id      = aws_apigatewayv2_authorizer.cognito_auth.id
  authorization_type = "JWT"
}

resource "aws_lambda_permission" "deleteApplication_api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.deleteApplication_lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.job_tracker_api.execution_arn}/*/*"
}

# getApplications route
resource "aws_apigatewayv2_integration" "getApplications_lambda_integration" {
  api_id = aws_apigatewayv2_api.job_tracker_api.id

  integration_uri    = var.getApplication_lambda_integration_invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "getApplications_lambda_route" {
  api_id = aws_apigatewayv2_api.job_tracker_api.id

  route_key = "GET /applications"
  target    = "integrations/${aws_apigatewayv2_integration.getApplications_lambda_integration.id}"

  # to enable Cognito auth: attach the authorizer to the route
  authorizer_id      = aws_apigatewayv2_authorizer.cognito_auth.id
  authorization_type = "JWT"
}

resource "aws_lambda_permission" "getApplications_api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.getApplication_lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.job_tracker_api.execution_arn}/*/*"
}

# updateApplication route
resource "aws_apigatewayv2_integration" "updateApplication_lambda_integration" {
  api_id = aws_apigatewayv2_api.job_tracker_api.id

  integration_uri    = var.updateApplication_lambda_integration_invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "updateApplication_lambda_route" {
  api_id = aws_apigatewayv2_api.job_tracker_api.id

  route_key = "PUT /updateApplication"
  target    = "integrations/${aws_apigatewayv2_integration.updateApplication_lambda_integration.id}"

  # to enable Cognito auth: attach the authorizer to the route
  authorizer_id      = aws_apigatewayv2_authorizer.cognito_auth.id
  authorization_type = "JWT"
}

resource "aws_lambda_permission" "updateApplication_api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.updateApplication_lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.job_tracker_api.execution_arn}/*/*"
}

# we know have a working API configured with no authentication. To enable authentication,
# we will create a Cognito authorizer and attach it to the API Gateway routes
resource "aws_apigatewayv2_authorizer" "cognito_auth" {
  name             = "cognito-authorizer"
  api_id           = aws_apigatewayv2_api.job_tracker_api.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    audience = [var.cognito_user_pool_client_id]
    issuer   = "https://${var.cognito_user_pool_endpoint}"
  }
}