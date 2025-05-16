############################################################################################################################
######## 2.a. Creating the bucket and associated policies that will be used to store the archive containing the
######## functions source code and dependencies #############################################################################
############################################################################################################################
resource "random_pet" "lambdas_bucket_name" {
  prefix = "lambdas-job-tracker-aws"
  length = 3
}

resource "aws_s3_bucket" "lambdas_bucket" {
  bucket = random_pet.lambdas_bucket_name.id
}

# set the ownership of the bucket to the account that created it
resource "aws_s3_bucket_ownership_controls" "lambda_bucket" {
  bucket = aws_s3_bucket.lambdas_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "lambdas_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.lambda_bucket]

  bucket = aws_s3_bucket.lambdas_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "lambdas_bucket" {
  bucket = aws_s3_bucket.lambdas_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

############################################################################################################
######## 2.b. Packaging and copying the lambda functions to the S3 bucket ########
############################################################################################################
# createApplication lambda function
data "archive_file" "lambda_create" {
  type = "zip"

  source_dir  = "${path.module}/../../../../backend/lambdas/createApplication/"
  output_path = "${path.module}/../../../../backend/lambdas/createApplication/createApplication.zip"
}

resource "aws_s3_object" "lambda_create" {
  bucket = aws_s3_bucket.lambdas_bucket.id
  key    = "createApplication.zip"
  source = data.archive_file.lambda_create.output_path

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5(data.archive_file.lambda_create.output_path)
}

# deleteApplication lambda function
data "archive_file" "lambda_delete" {
  type = "zip"

  source_dir  = "${path.module}/../../../../backend/lambdas/deleteApplication/"
  output_path = "${path.module}/../../../../backend/lambdas/deleteApplication/deleteApplication.zip"
}

resource "aws_s3_object" "lambda_delete" {
  bucket = aws_s3_bucket.lambdas_bucket.id
  key    = "deleteApplication.zip"
  source = data.archive_file.lambda_delete.output_path

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5(data.archive_file.lambda_delete.output_path)
}

# getApplications lamnda function
data "archive_file" "lambda_get" {
  type = "zip"

  source_dir  = "${path.module}/../../../../backend/lambdas/getApplications/"
  output_path = "${path.module}/../../../../backend/lambdas/getApplications/getApplications.zip"
}

resource "aws_s3_object" "lambda_get" {
  bucket = aws_s3_bucket.lambdas_bucket.id
  key    = "getApplication.zip"
  source = data.archive_file.lambda_get.output_path

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5(data.archive_file.lambda_get.output_path)
}

# updateApplication lambda function
data "archive_file" "lambda_update" {
  type = "zip"

  source_dir  = "${path.module}/../../../../backend/lambdas/updateApplication/"
  output_path = "${path.module}/../../../../backend/lambdas/updateApplication/updateApplication.zip"
}

resource "aws_s3_object" "lambda_update" {
  bucket = aws_s3_bucket.lambdas_bucket.id
  key    = "updateApplication.zip"
  source = data.archive_file.lambda_update.output_path

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5(data.archive_file.lambda_update.output_path)
}

######################################################################################
######## 2.c. Defining the lambda functions and related resources ###
######################################################################################
resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = var.dynamodb_access_policy_arn
}

# createApplication lambda function
resource "aws_lambda_function" "createApplication" {
  function_name = "createApplication"
  description   = "Create a new application in the job tracker system"

  s3_bucket = aws_s3_bucket.lambdas_bucket.id
  s3_key    = aws_s3_object.lambda_create.key

  runtime = "python3.9"
  handler = "main.lambda_handler" # entrypoint of the lambda function

  source_code_hash = data.archive_file.lambda_create.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "createApplication" {
  name = "/aws/lambda/${aws_lambda_function.createApplication.function_name}"

  retention_in_days = 7
}

# deleteApplication lambda function
resource "aws_lambda_function" "deleteApplication" {
  function_name = "deleteApplication"
  description   = "Delete a new application in the job tracker system"

  s3_bucket = aws_s3_bucket.lambdas_bucket.id
  s3_key    = aws_s3_object.lambda_delete.key

  runtime = "python3.9"
  handler = "main.lambda_handler" # entrypoint of the lambda function

  source_code_hash = data.archive_file.lambda_delete.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "deleteApplication" {
  name = "/aws/lambda/${aws_lambda_function.deleteApplication.function_name}"

  retention_in_days = 7
}

# getApplications lambda function
resource "aws_lambda_function" "getApplications" {
  function_name = "getApplications"
  description   = "Get all applications in the job tracker system"

  s3_bucket = aws_s3_bucket.lambdas_bucket.id
  s3_key    = aws_s3_object.lambda_get.key

  runtime = "python3.9"
  handler = "main.lambda_handler" # entrypoint of the lambda function

  source_code_hash = data.archive_file.lambda_get.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "getApplications" {
  name = "/aws/lambda/${aws_lambda_function.getApplications.function_name}"

  retention_in_days = 7
}

# updateApplication lambda function
resource "aws_lambda_function" "updateApplication" {
  function_name = "updateApplication"
  description   = "Update a new application in the job tracker system"

  s3_bucket = aws_s3_bucket.lambdas_bucket.id
  s3_key    = aws_s3_object.lambda_update.key

  runtime = "python3.9"
  handler = "main.lambda_handler" # entrypoint of the lambda function

  source_code_hash = data.archive_file.lambda_update.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "updateApplication" {
  name = "/aws/lambda/${aws_lambda_function.updateApplication.function_name}"

  retention_in_days = 7
}

