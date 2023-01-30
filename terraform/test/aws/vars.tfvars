# Network
region = "us-west-2" # "eu-west-1"

vpc_cidr_block = "10.19.0.0/16"

availability_zone = "us-west-2a"

igw_route_destination_cidr_block = "0.0.0.0/0"

security_group_name = "multi-cloud-security-group"

security_group_description = "Security Group for Multi Cloud"

ssh_allowed_ip_addresses = []

http_allowed_ip_addresses = ["0.0.0.0/0"]

egress_cidr_blocks = ["0.0.0.0/0"]

# Instance
ami_id = "ami-0efa4e295b4c8c729"

key_pair_name = "multi-cloud-key-pair"

instance_type = "t2.micro"