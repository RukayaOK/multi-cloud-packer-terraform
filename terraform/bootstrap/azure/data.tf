data "azurerm_subscription" "subscription" {}

data "github_repository" "packer_github_repo" {
  full_name = var.github_repository
}

data "azurerm_client_config" "current" {}

data "http" "ip" {
  url = "https://ifconfig.me/ip"
}

output "ip" {
  value = data.http.ip.response_body
}