data "google_service_account_key" "packer_account_key" {
  name            = google_service_account_key.packer_account_key.name
  public_key_type = "TYPE_X509_PEM_FILE"
}

data "github_repository" "packer_github_repo" {
  full_name = var.github_repository
}

data "http" "ip" {
  url = "https://ifconfig.me/ip"
}