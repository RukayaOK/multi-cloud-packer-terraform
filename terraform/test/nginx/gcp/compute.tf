resource "google_compute_address" "main" {
  name    = var.ip_name
  project = var.project
  region  = var.region
}

# Create VM for web server
resource "google_compute_instance" "main" {
  name         = var.instance_name
  machine_type = var.instance_type
  zone         = var.zone
  tags         = ["ssh", "http"]

  boot_disk {
    initialize_params {
      image = "${var.project}/${var.image_name}"
    }
  }

  network_interface {
    network    = google_compute_network.main.name
    subnetwork = google_compute_subnetwork.main.name
    access_config {
      nat_ip = google_compute_address.main.address
    }
  }
}

