data "http" "ip" {
  url = "https://ifconfig.me/ip"
}

data "aws_ami" "main" {
  most_recent = true
  owners      = [var.ami_owner]

  filter {
    name   = "name"
    values = ["${var.ami_name_filter}*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}