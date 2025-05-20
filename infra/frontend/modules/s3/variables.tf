variable "frontend_react_files_directory" {
  description = "Path to the React frontend source directory"
  type        = string
}

variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "eu-west-3"
}