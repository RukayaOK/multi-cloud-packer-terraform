project_id   = "mypackerproject-373111"
source_image = "centos-7-v20221206"

ssh_username = "packer"
zone         = "europe-west2-a"

disk_size    = 20
disk_type    = "pd-ssd"
machine_type = "n1-standard-2"

image_family      = "nginx"
image_name        = "nginx-image"
image_description = "Packer Built NGINX Image"

network    = "projects/mypackerproject-373111/global/networks/packer-vpc"
subnetwork = "projects/mypackerproject-373111/regions/europe-west2/subnetworks/packer-subnetwork"

metadata = {
  Department = "Engineering"
  Task       = "Image Deployment"
}