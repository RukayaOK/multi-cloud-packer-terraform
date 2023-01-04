
# Azure Location
location = "uksouth"

# Azure Resource Groups
packer_artifacts_resource_group            = "packer-artifacts-rg"
packer_build_resource_group                = "packer-build-rg"
packer_key_vault_resource_group            = "packer-key-vault-rg"
packer_shared_image_gallery_resource_group = "packer-shared-image-gallery-rg"

# Application
packer_azuread_application = "packer-sp-app"

# Key Vault
packer_key_vault = "mypackerkv4rok"

# GitHub 
github_repository  = "RukayaOK/packer-terraform-bootstrap"
github_environment = "AZURE"

# Azure Network
packer_build_vnet                 = "packer-build-vnet"
packer_build_subnet               = "packer-build-subnet"
packer_build_vnet_address_space   = ["10.1.0.0/24"]
packer_build_subnet_address_space = ["10.1.0.0/24"]
packer_build_subnet_nsg           = "packer-build-subnet-nsg"

allowed_ip_addresses = []

# Azure Image Gallery
packer_shared_image_gallery             = "packer_shared_image_gallery"
packer_shared_image_gallery_description = "Shared images gallery for packer"