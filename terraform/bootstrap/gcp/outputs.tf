output "packer_private_key" {
  value     = google_service_account_key.packer_account_key.private_key
  sensitive = true
}

output "service_account_email" {
  value = google_service_account.packer_account.email
}

output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "subnet_id" {
  value = google_compute_subnetwork.subnet.id
}