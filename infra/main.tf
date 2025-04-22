provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      project = "job-tracker-aws"
    }
  }
}

############################################################################################################################
######## Creating the DynamoDB table that will be used to store the job tracker application data ###########################
############################################################################################################################
resource "aws_dynamodb_table" "applications_dynamodb_table" {
  name         = "job_applications"
  billing_mode = "PAY_PER_REQUEST" # auto-scale sans provisioning

  hash_key  = "user_id"
  range_key = "job_id"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "job_id"
    type = "S"
  }

  tags = {
    Environment = "dev"
    Project     = "job-tracker-aws"
  }
}

# corresponding IAM policy that will be attached to the lambda functions
resource "aws_iam_policy" "dynamodb_access_policy" {
  name        = "lambda-dynamodb-policy"
  description = "Allow Lambda to read/write to DynamoDB table"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.applications_dynamodb_table.arn
      },
    ]
  })
}


############################################################################################################################
######## Creating the bucket and associated policies that will be used to store the archive containing the createApplication
######## function source code and dependencies #############################################################################
############################################################################################################################
resource "random_pet" "lambda_create_bucket_name" {
  prefix = "lambda-create-job-tracker-aws"
  length = 3
}

resource "aws_s3_bucket" "lambda_create_bucket" {
  bucket = random_pet.lambda_create_bucket_name.id
}

# set the ownership of the bucket to the account that created it
resource "aws_s3_bucket_ownership_controls" "lambda_create_bucket" {
  bucket = aws_s3_bucket.lambda_create_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "lambda_create_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.lambda_create_bucket]

  bucket = aws_s3_bucket.lambda_create_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "lambda_create_bucket" {
  bucket = aws_s3_bucket.lambda_create_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

############################################################################################################
######## Packaging and copying the createApplication lambda function to its corresponding S3 bucket ########
############################################################################################################
data "archive_file" "lambda_create" {
  type = "zip"

  source_dir  = "${path.module}/../backend/lambdas/createApplication/"
  output_path = "${path.module}/../backend/lambdas/createApplication/createApplication.zip"
}

resource "aws_s3_object" "lambda_create" {
  bucket = aws_s3_bucket.lambda_create_bucket.id
  key    = "createApplication.zip"
  source = data.archive_file.lambda_create.output_path

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5(data.archive_file.lambda_create.output_path)
}

######################################################################################
######## Defining the createApplication lambda function and related resources ########
######################################################################################
resource "aws_lambda_function" "createApplication" {
  function_name = "createApplication"
  description   = "Create a new application in the job tracker system"

  s3_bucket = aws_s3_bucket.lambda_create_bucket.id
  s3_key    = aws_s3_object.lambda_create.key

  runtime = "python3.9"
  handler = "main.lambda_handler" # entrypoint of the lambda function

  source_code_hash = data.archive_file.lambda_create.output_base64sha256

  role = aws_iam_role.lambda_create_exec.arn
}

resource "aws_cloudwatch_log_group" "createApplication" {
  name = "/aws/lambda/${aws_lambda_function.createApplication.function_name}"

  retention_in_days = 7
}

resource "aws_iam_role" "lambda_create_exec" {
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

resource "aws_iam_role_policy_attachment" "lambda_create_policy" {
  role       = aws_iam_role.lambda_create_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_create_dynamodb_policy" {
  role       = aws_iam_role.lambda_create_exec.name
  policy_arn = aws_iam_policy.dynamodb_access_policy.arn
}
