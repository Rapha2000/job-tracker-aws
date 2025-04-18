provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      project = "job-tracker-aws"
    }
  }
}


# Creating the bucket and associated policies that will be used to store the archive containing the function 
# source code and any dependencies.
resource "random_pet" "lambda_create_bucket_name" {
  prefix = "lambda-create-job-tracker-aws"
  length = 4
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

# package and copy the createApplication lambda function to its corresponding S3 bucket
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
