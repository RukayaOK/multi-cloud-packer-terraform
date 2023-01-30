resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.ip_cidr_range
  network       = google_compute_network.vpc.id
  region        = var.region
}

resource "google_compute_firewall" "allow-internal" {
  name    = var.internal_firewall_name
  network = google_compute_network.vpc.name
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = [var.ip_cidr_range]
}

resource "google_compute_firewall" "allow-ssh" {
  name    = var.ssh_firewall_name
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = concat([data.http.ip.response_body], var.allowed_ip_addresses)
}

