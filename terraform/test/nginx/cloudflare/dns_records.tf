resource "cloudflare_record" "azure_www" {
  zone_id = var.CLOUDFLARE_ZONE_ID
  name    = "www"
  value   = data.terraform_remote_state.azure.outputs.public_ip #data.azurerm_public_ip.main.ip_address
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "aws_www" {
  zone_id = var.CLOUDFLARE_ZONE_ID
  name    = "www"
  value   = data.terraform_remote_state.aws.outputs.public_ip #data.aws_eip.main[0].public_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "gcp_www" {
  zone_id = var.CLOUDFLARE_ZONE_ID
  name    = "www"
  value   = data.terraform_remote_state.gcp.outputs.public_ip #data.google_compute_address.main.address
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "azure_root" {
  zone_id = var.CLOUDFLARE_ZONE_ID
  name    = "@"
  value   = data.terraform_remote_state.azure.outputs.public_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "aws_root" {
  zone_id = var.CLOUDFLARE_ZONE_ID
  name    = "@"
  value   = data.terraform_remote_state.aws.outputs.public_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "gcp_root" {
  zone_id = var.CLOUDFLARE_ZONE_ID
  name    = "@"
  value   = data.terraform_remote_state.gcp.outputs.public_ip
  type    = "A"
  proxied = true
}
