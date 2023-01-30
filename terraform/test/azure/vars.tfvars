location = "uksouth"

resource_group_name = "multi-cloud-rg"

vnet_name = "multi-cloud-vnet"

vnet_address_space = ["10.11.0.0/16"]

subnet_name = "multi-cloud-subnet"

subnet_address_space = ["10.11.0.0/24"]

subnet_nsg_name = "multi-cloud-subnet-nsg"

http_allowed_ip_addresses = ["0.0.0.0/0"]

ssh_allowed_ip_addresses = []

public_ip_name = "multi-cloud-vm-public-ip"

public_ip_allocation_method = "Static"

nic_name = "multi-cloud-vm-nic"

nic_ip_config_name = "multi-cloud-vm-private-ip" # internal

nic_ip_config_private_ip_allocation_method = "Dynamic"

vm_name = "multi-cloud-vm"

vm_size = "Standard_B1s"

delete_os_disk_on_termination = true

delete_data_disks_on_termination = true

image_name = "nginx-packer-2023-01"

image_resource_group_name = "packer-artifacts-rg"

storage_os_disk_name              = "myosdisk1"
storage_os_disk_caching           = "ReadWrite"
storage_os_disk_create_option     = "FromImage"
storage_os_disk_managed_disk_type = "Standard_LRS"

key_pair_name = "multi-cloud-key-pair"

vm_hostname       = "hostname"
vm_admin_username = "testadmin"