# User and Policy
aws_iam_user_name = "packer-user"

aws_iam_policy_name = "packer-policy"

aws_iam_policy_definition = "Packer Policy Definition"

aws_policy_file_path = "policy-packer.json"

policy_attachment_name = "packer-policy-attachment"

# Secret Manager Credentials
aws_secretsmanager_secret_access_key_name = "packer_access_key"

aws_secretsmanager_secret_access_description = "Packer Access Key"

aws_secretsmanager_secret_version_secret_key_name = "packer_secret_key"

aws_secretsmanager_secret_version_secret_key_description = "Packer Secret Key"

# Network
region = "us-west-2"

vpc_cidr_block = "10.0.0.0/16"

availability_zone = "us-west-2a"

igw_route_destination_cidr_block = "0.0.0.0/0"

security_group_name = "packer-security-group"

security_group_description = "Security Group for Packer"

allowed_ip_addresses = ["51.182.202.178/32", "51.182.206.247/32"]

egress_cidr_blocks = ["0.0.0.0/0"]

# GitHub 
github_repository  = "RukayaOK/packer-terraform-bootstrap"
github_environment = "AWS"