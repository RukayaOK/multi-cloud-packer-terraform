resource "github_actions_secret" "packer_service_account_email" {
  repository      = data.github_repository.packer_github_repo.name
  secret_name     = "PKR_VAR_GCP_SERVICE_ACCOUNT_EMAIL"
  encrypted_value = base64encode(google_service_account.packer_account.email)
}

resource "github_actions_secret" "packer_account_credentials" {
  repository      = data.github_repository.packer_github_repo.name
  secret_name     = "PKR_VAR_GCP_ACCOUNT_CREDENTIALS"
  encrypted_value = base64encode(google_service_account_key.packer_account_key.private_key)
}
