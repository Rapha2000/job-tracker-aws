resource "random_string" "s3_bucket_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_s3_bucket" "job-tracker-website-bucket" {
  bucket        = "job-tracker-website-${random_string.s3_bucket_suffix.result}"
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "job-tracker-website-bucket-configuration" {
  bucket = aws_s3_bucket.job-tracker-website-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "job-tracker-website-bucket-public-access-block" {
  bucket = aws_s3_bucket.job-tracker-website-bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "static_site_upload_object" {
  for_each = fileset("${var.frontend_react_files_directory}/dist", "**")
  bucket   = aws_s3_bucket.job-tracker-website-bucket.id
  key      = each.value
  source   = "${var.frontend_react_files_directory}/dist/${each.value}"
  etag     = filemd5("${var.frontend_react_files_directory}/dist/${each.value}")
  content_type = lookup(
    {
      ".html" = "text/html"
      ".css"  = "text/css"
      ".js"   = "application/javascript"
      ".png"  = "image/png"
      ".jpg"  = "image/jpeg"
      ".gif"  = "image/gif"
    },
    regex("\\.[^.]+$", each.value), // ou fileext(each.value) si dispo dans ton Terraform
    "application/octet-stream"
  )
  depends_on = [ 
    aws_s3_bucket.job-tracker-website-bucket,
    aws_s3_bucket_website_configuration.job-tracker-website-bucket-configuration,
    aws_s3_bucket_public_access_block.job-tracker-website-bucket-public-access-block,
   ]
}