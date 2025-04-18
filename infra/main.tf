provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      project = "job-tracker-aws"
    }
  }
}

resource "random_pet" "lambda_create_bucket_name" {
  prefix = "lambda-create-job-tracker-aws"
  length = 4
}

resource "aws_s3_bucket" "lambda_create_bucket" {
  bucket = random_pet.lambda_create_bucket_name.id
}

# this is to set the ownership of the bucket to the account that created it
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
