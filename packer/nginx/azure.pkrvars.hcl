build_resource_group_name              = "packer-build-rg"
virtual_network_name                   = "packer-build-vnet"
virtual_network_subnet_name            = "packer-build-subnet"
private_virtual_network_with_public_ip = "true"
vm_size                                = "Standard_DS2_v2"

managed_image_resource_group_name = "packer-artifacts-rg"
managed_image_name                = "nginx-packer-2022-12"
os_type                           = "Linux"
image_publisher                   = "OpenLogic"
image_offer                       = "CentOS"
image_sku                         = "7.3"

azure_tags_department = "Engineering"
azure_tags_task       = "Image Deployment"

shared_image_gallery_destination_resource_group_name = "packer-shared-image-gallery-rg"
shared_image_gallery_destination_gallery_name        = "packer_shared_image_gallery"
managed_image_version                                = "1.0.0"
managed_image_definition                             = "centos-image"
replication_regions                                  = ["uksouth", "ukwest"]
storage_account_type                                 = "Standard_LRS"