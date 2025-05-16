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