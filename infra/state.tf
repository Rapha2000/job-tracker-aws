terraform {
  backend "s3" {
    bucket       = ""
    key          = ""
    region       = ""
    use_lockfile = true
  }
}

# specify path to the config file at init: `terraform init -backend-config="./state.config"`
