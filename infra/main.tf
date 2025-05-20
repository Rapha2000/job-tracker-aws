provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      project = "job-tracker-aws"
    }
  }
}

module "backend" {
  source = "./backend"

  aws_region = var.aws_region
}

module "frontend" {
  source = "./frontend"
  aws_region = var.aws_region
  cognito_user_pool_id = module.backend.user_pool_id
  cognito_user_pool_client_id = module.backend.cognito_client_id
  api_base_url = module.backend.api_base_url
  frontend_source_directory = "${path.module}/../frontend-client"
  
  depends_on = [ module.backend ]
}











############################################################################################################################
######## 1. Creating the DynamoDB table that will be used to store the job tracker application data ###########################
############################################################################################################################
# resource "aws_dynamodb_table" "applications_dynamodb_table" {
#   name         = "job_applications"
#   billing_mode = "PAY_PER_REQUEST" # auto-scale sans provisioning

#   hash_key  = "user_id"
#   range_key = "job_id"

#   attribute {
#     name = "user_id"
#     type = "S"
#   }

#   attribute {
#     name = "job_id"
#     type = "S"
#   }

#   tags = {
#     Environment = "dev"
#     Project     = "job-tracker-aws"
#   }
# }

# # corresponding IAM policy that will be attached to the lambda functions
# resource "aws_iam_policy" "dynamodb_access_policy" {
#   name        = "lambda-dynamodb-policy"
#   description = "Allow Lambda to read/write to DynamoDB table"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "dynamodb:PutItem",
#           "dynamodb:GetItem",
#           "dynamodb:UpdateItem",
#           "dynamodb:DeleteItem",
#           "dynamodb:Scan",
#           "dynamodb:Query"
#         ]
#         Effect   = "Allow"
#         Resource = aws_dynamodb_table.applications_dynamodb_table.arn
#       },
#     ]
#   })
# }


############################################################################################################################
######## 2. Lambdas lambda #######################################################################################
############################################################################################################################
######## 2.a. Creating the bucket and associated policies that will be used to store the archive containing the
######## functions source code and dependencies #############################################################################
############################################################################################################################
# resource "random_pet" "lambdas_bucket_name" {
#   prefix = "lambdas-job-tracker-aws"
#   length = 3
# }

# resource "aws_s3_bucket" "lambdas_bucket" {
#   bucket = random_pet.lambdas_bucket_name.id
# }

# # set the ownership of the bucket to the account that created it
# resource "aws_s3_bucket_ownership_controls" "lambda_bucket" {
#   bucket = aws_s3_bucket.lambdas_bucket.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# resource "aws_s3_bucket_acl" "lambdas_bucket" {
#   depends_on = [aws_s3_bucket_ownership_controls.lambda_bucket]

#   bucket = aws_s3_bucket.lambdas_bucket.id
#   acl    = "private"
# }

# resource "aws_s3_bucket_public_access_block" "lambdas_bucket" {
#   bucket = aws_s3_bucket.lambdas_bucket.id

#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

# ############################################################################################################
# ######## 2.b. Packaging and copying the lambda functions to the S3 bucket ########
# ############################################################################################################
# # createApplication lambda function
# data "archive_file" "lambda_create" {
#   type = "zip"

#   source_dir  = "${path.module}/../backend/lambdas/createApplication/"
#   output_path = "${path.module}/../backend/lambdas/createApplication/createApplication.zip"
# }

# resource "aws_s3_object" "lambda_create" {
#   bucket = aws_s3_bucket.lambdas_bucket.id
#   key    = "createApplication.zip"
#   source = data.archive_file.lambda_create.output_path

#   # The filemd5() function is available in Terraform 0.11.12 and later
#   # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
#   # etag = "${md5(file("path/to/file"))}"
#   etag = filemd5(data.archive_file.lambda_create.output_path)
# }

# # deleteApplication lambda function
# data "archive_file" "lambda_delete" {
#   type = "zip"

#   source_dir  = "${path.module}/../backend/lambdas/deleteApplication/"
#   output_path = "${path.module}/../backend/lambdas/deleteApplication/deleteApplication.zip"
# }

# resource "aws_s3_object" "lambda_delete" {
#   bucket = aws_s3_bucket.lambdas_bucket.id
#   key    = "deleteApplication.zip"
#   source = data.archive_file.lambda_delete.output_path

#   # The filemd5() function is available in Terraform 0.11.12 and later
#   # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
#   # etag = "${md5(file("path/to/file"))}"
#   etag = filemd5(data.archive_file.lambda_delete.output_path)
# }

# # getApplications lamnda function
# data "archive_file" "lambda_get" {
#   type = "zip"

#   source_dir  = "${path.module}/../backend/lambdas/getApplications/"
#   output_path = "${path.module}/../backend/lambdas/getApplications/getApplications.zip"
# }

# resource "aws_s3_object" "lambda_get" {
#   bucket = aws_s3_bucket.lambdas_bucket.id
#   key    = "getApplication.zip"
#   source = data.archive_file.lambda_get.output_path

#   # The filemd5() function is available in Terraform 0.11.12 and later
#   # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
#   # etag = "${md5(file("path/to/file"))}"
#   etag = filemd5(data.archive_file.lambda_get.output_path)
# }

# # updateApplication lambda function
# data "archive_file" "lambda_update" {
#   type = "zip"

#   source_dir  = "${path.module}/../backend/lambdas/updateApplication/"
#   output_path = "${path.module}/../backend/lambdas/updateApplication/updateApplication.zip"
# }

# resource "aws_s3_object" "lambda_update" {
#   bucket = aws_s3_bucket.lambdas_bucket.id
#   key    = "updateApplication.zip"
#   source = data.archive_file.lambda_update.output_path

#   # The filemd5() function is available in Terraform 0.11.12 and later
#   # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
#   # etag = "${md5(file("path/to/file"))}"
#   etag = filemd5(data.archive_file.lambda_update.output_path)
# }

######################################################################################
######## 2.c. Defining the lambda functions and related resources ###
######################################################################################
# resource "aws_iam_role" "lambda_exec" {
#   name = "serverless_lambda"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Sid    = ""
#       Principal = {
#         Service = "lambda.amazonaws.com"
#       }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "lambda_policy" {
#   role       = aws_iam_role.lambda_exec.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }

# resource "aws_iam_role_policy_attachment" "lambda_dynamodb_policy" {
#   role       = aws_iam_role.lambda_exec.name
#   policy_arn = aws_iam_policy.dynamodb_access_policy.arn
# }

# # createApplication lambda function
# resource "aws_lambda_function" "createApplication" {
#   function_name = "createApplication"
#   description   = "Create a new application in the job tracker system"

#   s3_bucket = aws_s3_bucket.lambdas_bucket.id
#   s3_key    = aws_s3_object.lambda_create.key

#   runtime = "python3.9"
#   handler = "main.lambda_handler" # entrypoint of the lambda function

#   source_code_hash = data.archive_file.lambda_create.output_base64sha256

#   role = aws_iam_role.lambda_exec.arn
# }

# resource "aws_cloudwatch_log_group" "createApplication" {
#   name = "/aws/lambda/${aws_lambda_function.createApplication.function_name}"

#   retention_in_days = 7
# }

# # deleteApplication lambda function
# resource "aws_lambda_function" "deleteApplication" {
#   function_name = "deleteApplication"
#   description   = "Delete a new application in the job tracker system"

#   s3_bucket = aws_s3_bucket.lambdas_bucket.id
#   s3_key    = aws_s3_object.lambda_delete.key

#   runtime = "python3.9"
#   handler = "main.lambda_handler" # entrypoint of the lambda function

#   source_code_hash = data.archive_file.lambda_delete.output_base64sha256

#   role = aws_iam_role.lambda_exec.arn
# }

# resource "aws_cloudwatch_log_group" "deleteApplication" {
#   name = "/aws/lambda/${aws_lambda_function.deleteApplication.function_name}"

#   retention_in_days = 7
# }

# # getApplications lambda function
# resource "aws_lambda_function" "getApplications" {
#   function_name = "getApplications"
#   description   = "Get all applications in the job tracker system"

#   s3_bucket = aws_s3_bucket.lambdas_bucket.id
#   s3_key    = aws_s3_object.lambda_get.key

#   runtime = "python3.9"
#   handler = "main.lambda_handler" # entrypoint of the lambda function

#   source_code_hash = data.archive_file.lambda_get.output_base64sha256
#   role             = aws_iam_role.lambda_exec.arn
# }

# resource "aws_cloudwatch_log_group" "getApplications" {
#   name = "/aws/lambda/${aws_lambda_function.getApplications.function_name}"

#   retention_in_days = 7
# }

# # updateApplication lambda function
# resource "aws_lambda_function" "updateApplication" {
#   function_name = "updateApplication"
#   description   = "Update a new application in the job tracker system"

#   s3_bucket = aws_s3_bucket.lambdas_bucket.id
#   s3_key    = aws_s3_object.lambda_update.key

#   runtime = "python3.9"
#   handler = "main.lambda_handler" # entrypoint of the lambda function

#   source_code_hash = data.archive_file.lambda_update.output_base64sha256
#   role             = aws_iam_role.lambda_exec.arn
# }

# resource "aws_cloudwatch_log_group" "updateApplication" {
#   name = "/aws/lambda/${aws_lambda_function.updateApplication.function_name}"

#   retention_in_days = 7
# }

######################################################################################
######## 3. Creating the HTTP API Gateway that will be used to trigger the lambda functions
######################################################################################
# resource "aws_apigatewayv2_api" "job_tracker_api" {
#   name          = "job-tracker-api"
#   protocol_type = "HTTP"
#   description   = "API Gateway for the job tracker application"
#   cors_configuration {
#     allow_credentials = false
#     allow_headers     = ["Content-Type", "Authorization"]
#     allow_methods = ["OPTIONS", "GET", "POST", "PUT", "DELETE"]
#     allow_origins = ["*"]
#     expose_headers    = []
#     max_age           = 3600
#   }
# }

# resource "aws_cloudwatch_log_group" "log_group_api_gw" {
#   name = "/aws/apigateway/job-tracker-api"

#   retention_in_days = 7
# }

# resource "aws_apigatewayv2_stage" "lambda_stage" {
#   api_id      = aws_apigatewayv2_api.job_tracker_api.id
#   name        = "dev"
#   auto_deploy = true

#   access_log_settings {
#     destination_arn = aws_cloudwatch_log_group.log_group_api_gw.arn

#     format = jsonencode({
#       requestId               = "$context.requestId"
#       sourceIp                = "$context.identity.sourceIp"
#       requestTime             = "$context.requestTime"
#       protocol                = "$context.protocol"
#       httpMethod              = "$context.httpMethod"
#       resourcePath            = "$context.resourcePath"
#       routeKey                = "$context.routeKey"
#       status                  = "$context.status"
#       responseLength          = "$context.responseLength"
#       integrationErrorMessage = "$context.integrationErrorMessage"
#       }
#     )
#   }
# }

# # createApplication route
# resource "aws_apigatewayv2_integration" "createApplication_lambda_integration" {
#   api_id = aws_apigatewayv2_api.job_tracker_api.id

#   integration_uri    = aws_lambda_function.createApplication.invoke_arn
#   integration_type   = "AWS_PROXY"
#   integration_method = "POST"
# }

# resource "aws_apigatewayv2_route" "createApplication_lambda_route" {
#   api_id = aws_apigatewayv2_api.job_tracker_api.id

#   route_key = "POST /createApplication"
#   target    = "integrations/${aws_apigatewayv2_integration.createApplication_lambda_integration.id}"

#   # to enable Cognito auth: attach the authorizer to the route
#   authorizer_id      = aws_apigatewayv2_authorizer.cognito_auth.id
#   authorization_type = "JWT"
# }

# resource "aws_lambda_permission" "createApplication_api_gw" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.createApplication.function_name
#   principal     = "apigateway.amazonaws.com"

#   source_arn = "${aws_apigatewayv2_api.job_tracker_api.execution_arn}/*/*"
# }

# # deleteApplication route
# resource "aws_apigatewayv2_integration" "deleteApplication_lambda_integration" {
#   api_id = aws_apigatewayv2_api.job_tracker_api.id

#   integration_uri    = aws_lambda_function.deleteApplication.invoke_arn
#   integration_type   = "AWS_PROXY"
#   integration_method = "POST"
# }

# resource "aws_apigatewayv2_route" "deleteApplication_lambda_route" {
#   api_id = aws_apigatewayv2_api.job_tracker_api.id

#   route_key = "POST /deleteApplication"
#   target    = "integrations/${aws_apigatewayv2_integration.deleteApplication_lambda_integration.id}"

#   # to enable Cognito auth: attach the authorizer to the route
#   authorizer_id      = aws_apigatewayv2_authorizer.cognito_auth.id
#   authorization_type = "JWT"
# }

# resource "aws_lambda_permission" "deleteApplication_api_gw" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.deleteApplication.function_name
#   principal     = "apigateway.amazonaws.com"

#   source_arn = "${aws_apigatewayv2_api.job_tracker_api.execution_arn}/*/*"
# }

# # getApplications route
# resource "aws_apigatewayv2_integration" "getApplications_lambda_integration" {
#   api_id = aws_apigatewayv2_api.job_tracker_api.id

#   integration_uri    = aws_lambda_function.getApplications.invoke_arn
#   integration_type   = "AWS_PROXY"
#   integration_method = "POST"
# }

# resource "aws_apigatewayv2_route" "getApplications_lambda_route" {
#   api_id = aws_apigatewayv2_api.job_tracker_api.id

#   route_key = "GET /applications"
#   target    = "integrations/${aws_apigatewayv2_integration.getApplications_lambda_integration.id}"

#   # to enable Cognito auth: attach the authorizer to the route
#   authorizer_id      = aws_apigatewayv2_authorizer.cognito_auth.id
#   authorization_type = "JWT"
# }

# resource "aws_lambda_permission" "getApplications_api_gw" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.getApplications.function_name
#   principal     = "apigateway.amazonaws.com"

#   source_arn = "${aws_apigatewayv2_api.job_tracker_api.execution_arn}/*/*"
# }

# # updateApplication route
# resource "aws_apigatewayv2_integration" "updateApplication_lambda_integration" {
#   api_id = aws_apigatewayv2_api.job_tracker_api.id

#   integration_uri    = aws_lambda_function.updateApplication.invoke_arn
#   integration_type   = "AWS_PROXY"
#   integration_method = "POST"
# }

# resource "aws_apigatewayv2_route" "updateApplication_lambda_route" {
#   api_id = aws_apigatewayv2_api.job_tracker_api.id

#   route_key = "PUT /updateApplication"
#   target    = "integrations/${aws_apigatewayv2_integration.updateApplication_lambda_integration.id}"

#   # to enable Cognito auth: attach the authorizer to the route
#   authorizer_id      = aws_apigatewayv2_authorizer.cognito_auth.id
#   authorization_type = "JWT"
# }

# resource "aws_lambda_permission" "updateApplication_api_gw" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.updateApplication.function_name
#   principal     = "apigateway.amazonaws.com"

#   source_arn = "${aws_apigatewayv2_api.job_tracker_api.execution_arn}/*/*"
# }

# # we know have a working API configured with no authentication. To enable authentication,
# # we will create a Cognito authorizer and attach it to the API Gateway routes
# resource "aws_apigatewayv2_authorizer" "cognito_auth" {
#   name             = "cognito-authorizer"
#   api_id           = aws_apigatewayv2_api.job_tracker_api.id
#   authorizer_type  = "JWT"
#   identity_sources = ["$request.header.Authorization"]

#   jwt_configuration {
#     audience = [aws_cognito_user_pool_client.jobtracker_user_pool_client.id]
#     issuer   = "https://${aws_cognito_user_pool.jobtracker_user_pool.endpoint}"
#   }
# }


# ######################################################################################
# ######## 4. Creating the Cognito resources used for authentication and authorization
# ######################################################################################

# ## a. Creating the user pool
# resource "aws_cognito_user_pool" "jobtracker_user_pool" {
#   name = "jobtracker-user-pool"

#   auto_verified_attributes = ["email"]

#   password_policy {
#     minimum_length    = 8
#     require_lowercase = true
#     require_numbers   = true
#     require_symbols   = false
#     require_uppercase = true
#   }

#   account_recovery_setting {
#     recovery_mechanism {
#       name     = "verified_email"
#       priority = 1
#     }
#   }

# }

# ## b. Creating the user pool client
# resource "aws_cognito_user_pool_client" "jobtracker_user_pool_client" {
#   name         = "jobtracker-client"
#   user_pool_id = aws_cognito_user_pool.jobtracker_user_pool.id

#   generate_secret = false

#   explicit_auth_flows = [
#     "ALLOW_USER_PASSWORD_AUTH",
#     "ALLOW_REFRESH_TOKEN_AUTH",
#     "ALLOW_USER_SRP_AUTH"
#   ]

#   allowed_oauth_flows_user_pool_client = true
#   allowed_oauth_flows                  = ["code", "implicit"]
#   allowed_oauth_scopes                 = ["email", "openid", "profile"]
#   supported_identity_providers         = ["COGNITO"]

#   callback_urls = ["http://localhost:3000"]
#   logout_urls   = ["http://localhost:3000"]
# }

# ## c. Cognito domain (Hosted UI)
# resource "aws_cognito_user_pool_domain" "jobtracker_domain" {
#   domain       = "jobtracker-${random_id.domain_suffix.hex}"
#   user_pool_id = aws_cognito_user_pool.jobtracker_user_pool.id
# }

# resource "random_id" "domain_suffix" {
#   byte_length = 4
# }