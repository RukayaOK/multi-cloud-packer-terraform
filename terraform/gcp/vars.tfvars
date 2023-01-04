project = "mypackerproject-373111"
region  = "europe-west2"

# Network
vpc_name      = "packer-vpc"
subnet_name   = "packer-subnetwork"
ip_cidr_range = "10.1.0.0/24"

firewall_name = "packer-fw-allow-internal"

allowed_ip_addresses = ["0.0.0.0/0"]

# Service Account 
packer_account_id   = "packeruser"
packer_account_name = "packeruser"

# GitHub 
github_repository  = "RukayaOK/packer-terraform-bootstrap"
github_environment = "AWS"