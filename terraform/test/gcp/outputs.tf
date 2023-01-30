# Output
output "public_ip" {
  value = google_compute_address.main.address
}