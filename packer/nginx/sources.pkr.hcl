source "azure-arm" "nginx" {

  client_id       = "${var.AZURE_CLIENT_ID}"
  client_secret   = "${var.AZURE_CLIENT_SECRET}"
  subscription_id = "${var.AZURE_SUBSCRIPTION_ID}"
  tenant_id       = "${var.AZURE_TENANT_ID}"

  build_resource_group_name              = "${var.build_resource_group_name}"
  virtual_network_name                   = "${var.virtual_network_name}"
  virtual_network_subnet_name            = "${var.virtual_network_subnet_name}"
  private_virtual_network_with_public_ip = "${var.private_virtual_network_with_public_ip}"
  vm_size                                = "${var.vm_size}"
  os_type                           = "${var.os_type}"

  image_offer                       = "${var.image_offer}"
  image_publisher                   = "${var.image_publisher}"
  image_sku                         = "${var.image_sku}"
  managed_image_name                = "${var.managed_image_name}"
  managed_image_resource_group_name = "${var.managed_image_resource_group_name}"

  azure_tags = {
    department = "${var.azure_tags_department}"
    task       = "${var.azure_tags_task}"
  }

  shared_image_gallery_destination {
    gallery_name        = "${var.shared_image_gallery_destination_gallery_name}"
    image_name          = "${var.managed_image_definition}"
    image_version       = "${var.managed_image_version}"
    replication_regions = "${var.replication_regions}"
    resource_group      = "${var.shared_image_gallery_destination_resource_group_name}"
    subscription        = "${var.AZURE_SUBSCRIPTION_ID}"
  }

}

source "amazon-ebs" "nginx" {
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY

  communicator = var.communicator["communicator"]
  ssh_port     = var.communicator["port"]
  ssh_username = var.communicator["username"]

  region = var.region

  instance_type = var.instance_type
  vpc_id        = var.vpc_id
  subnet_id     = var.subnet_id

  ami_name = "${var.ami_name}-{{isotime \"2006-01-02\"}}"

  ami_description             = "Amazon Linux CIS with Cloudwatch Logs agent"
  associate_public_ip_address = "true"

  source_ami = var.source_ami

  run_tags = merge({
    "Name" = "packer-build-${var.ami_name}-{{isotime \"2006-01-02-15-04-05\"}}"
    },
    var.tags
  )

  run_volume_tags = {
    "Name" : "packer-build-${var.ami_name}-{{isotime \"2006-01-02-15-04-05\"}}"
  }

  snapshot_tags = {
    "Name" : "packer-build-${var.ami_name}-{{isotime \"2006-01-02-15-04-05\"}}"
  }

  tags = merge({
    Name          = "${var.ami_name}-{{isotime \"2006-01-02\"}}"
    OS_Version    = var.os_version
    Release       = var.release
    Base_AMI_Name = "{{ .SourceAMIName}}"
    },
    var.tags
  )
}

source "googlecompute" "nginx" {
  account_file          = var.gcp_account_credentials
  service_account_email = var.gcp_service_account_email

  project_id   = var.project_id
  source_image = var.source_image

  ssh_username = var.ssh_username
  zone         = var.zone

  disk_size    = var.disk_size
  disk_type    = var.disk_type
  machine_type = var.machine_type

  image_family      = var.image_family
  image_name        = var.image_name
  image_description = var.image_description

  network    = var.network
  subnetwork = var.subnetwork



  metadata = var.metadata
}