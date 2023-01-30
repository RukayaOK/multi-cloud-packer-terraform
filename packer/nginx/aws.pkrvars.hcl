region = "us-west-2"

communicator = {
  communicator = "ssh",
  port         = 22,
  username     = "centos"
}

instance_type = "t3.micro"
vpc_id        = "vpc-07921cda614645870"
subnet_id     = "subnet-09a6cbe53c7678e66"

ami_name = "packer-image-name"

source_ami = "ami-08c191625cfb7ee61"

os_version = "Centos 7.3"

release = "1.0.0"

tags = {
  "Department" = "Engineering"
  "Task"       = "Image Deployment"
}