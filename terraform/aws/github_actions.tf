resource "github_actions_secret" "packer_access_key" {
  repository      = data.github_repository.packer_github_repo.name
  secret_name     = "PKR_VAR_AWS_ACCESS_KEY"
  encrypted_value = base64encode(aws_iam_access_key.packer.id)
}

resource "github_actions_secret" "packer_secret_key" {
  repository      = data.github_repository.packer_github_repo.name
  secret_name     = "PKR_VAR_AWS_SECRET_KEY"
  encrypted_value = base64encode(aws_iam_access_key.packer.secret)
}
