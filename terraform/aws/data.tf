data "github_repository" "packer_github_repo" {
  full_name = var.github_repository
}

data "http" "ip" {
  url = "https://ifconfig.me/ip"
}