######################################################################################
######## 4. Creating the Cognito resources used for authentication and authorization
######################################################################################

## a. Creating the user pool
resource "aws_cognito_user_pool" "jobtracker_user_pool" {
  name = "jobtracker-user-pool"

  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
    require_uppercase = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

}

## b. Creating the user pool client
resource "aws_cognito_user_pool_client" "jobtracker_user_pool_client" {
  name         = "jobtracker-client"
  user_pool_id = aws_cognito_user_pool.jobtracker_user_pool.id

  generate_secret = false

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]
  supported_identity_providers         = ["COGNITO"]

  callback_urls = ["http://localhost:3000"]
  logout_urls   = ["http://localhost:3000"]
}

## c. Cognito domain (Hosted UI)
resource "aws_cognito_user_pool_domain" "jobtracker_domain" {
  domain       = "jobtracker-${random_id.domain_suffix.hex}"
  user_pool_id = aws_cognito_user_pool.jobtracker_user_pool.id
}

resource "random_id" "domain_suffix" {
  byte_length = 4
}