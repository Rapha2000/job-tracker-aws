resource "null_resource" "generate_env_file" {
  provisioner "local-exec" {
    command = <<EOT
echo "VITE_CLIENT_ID=${var.cognito_user_pool_client_id}" > ${var.frontend_source_directory}/.env
echo "VITE_API_URL=${var.api_base_url}" >> ${var.frontend_source_directory}/.env
echo "VITE_REGION=${var.aws_region}" >> ${var.frontend_source_directory}/.env
EOT
  }

  triggers = {
    client_id = var.cognito_user_pool_client_id
    api_url   = var.api_base_url
    region    = var.aws_region
  }
}

resource "null_resource" "build_react" {
  depends_on = [null_resource.generate_env_file]

  provisioner "local-exec" {
    command = "cd ${var.frontend_source_directory} && npm install && npm run build"
  }

  triggers = {
    frontend_source_directory = var.frontend_source_directory
  }
}


module "s3" {
  source = "./modules/s3"

  aws_region                     = var.aws_region
  frontend_react_files_directory = var.frontend_source_directory
  depends_on = [ null_resource.build_react ]
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