module "s3" {
  source = "./modules/s3"

  aws_region                     = var.aws_region
  frontend_react_files_directory = var.frontend_source_directory
}

module "cloudfront" {
  source = "./modules/cloudfront"

  aws_region                                      = var.aws_region
  job-tracker-website-bucket-arn                  = module.s3.job-tracker-website-bucket-arn
  job-tracker-website-bucket-id                   = module.s3.job-tracker-website-bucket-id
  job-tracker-website-bucket-regional-domain-name = module.s3.job-tracker-website-bucket-regional-domain-name
  frontend_react_files_directory                  = var.frontend_source_directory

  depends_on = [module.s3]
}