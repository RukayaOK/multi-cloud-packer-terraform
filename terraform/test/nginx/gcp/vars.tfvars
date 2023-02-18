project = "mypackerproject-373111"
region  = "europe-west2"

# Network
vpc_name      = "multi-cloud-vpc"
subnet_name   = "multi-cloud-subnetwork"
ip_cidr_range = "10.19.0.0/24"

internal_firewall_name = "multi-cloud-fw-allow-internal"

http_firewall_name = "multi-cloud-fw-allow-http"

ssh_firewall_name = "multi-cloud-fw-allow-ssh"

http_allowed_ip_addresses = ["0.0.0.0/0"]

ssh_allowed_ip_addresses = []

zone = "europe-west2-a"

ip_name = "multi-cloud-ip"

instance_name = "multi-cloud-instance"

instance_type = "f1-micro"

image_name = "nginx-image"