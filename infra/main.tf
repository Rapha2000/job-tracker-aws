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
  source                      = "./frontend"
  aws_region                  = var.aws_region
  cognito_user_pool_id        = module.backend.user_pool_id
  cognito_user_pool_client_id = module.backend.cognito_client_id
  api_base_url                = module.backend.api_base_url
  frontend_source_directory   = "${path.module}/../frontend-client"

  depends_on = [module.backend]
}