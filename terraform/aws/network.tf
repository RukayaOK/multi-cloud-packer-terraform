resource "aws_vpc" "packer" {
  cidr_block = var.vpc_cidr_block

  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "packer" {
  vpc_id = aws_vpc.packer.id
}

resource "aws_subnet" "packer" {
  vpc_id = aws_vpc.packer.id

  cidr_block        = cidrsubnet(aws_vpc.packer.cidr_block, 8, 1)
  availability_zone = var.availability_zone

  map_public_ip_on_launch = true
}

resource "aws_route_table" "packer" {
  vpc_id = aws_vpc.packer.id

}

resource "aws_route" "packer" {
  route_table_id = aws_route_table.packer.id

  destination_cidr_block = var.igw_route_destination_cidr_block
  gateway_id             = aws_internet_gateway.packer.id
}

resource "aws_route_table_association" "packer" {
  route_table_id = aws_route_table.packer.id
  subnet_id      = aws_subnet.packer.id
}

resource "aws_security_group" "packer" {
  name        = var.security_group_name
  description = var.security_group_description

  vpc_id = aws_vpc.packer.id

}

resource "aws_security_group_rule" "packer_ingress_allow_icmp" {
  type = "ingress"

  protocol  = "icmp"
  from_port = -1
  to_port   = -1

  cidr_blocks = concat(["${data.http.ip.response_body}/32"], var.allowed_ip_addresses)

  security_group_id = aws_security_group.packer.id
}

resource "aws_security_group_rule" "packer_ingress_allow_ssh" {
  type = "ingress"

  protocol  = "tcp"
  from_port = 22
  to_port   = 22

  cidr_blocks = concat(["${data.http.ip.response_body}/32"], var.allowed_ip_addresses)

  security_group_id = aws_security_group.packer.id
}

resource "aws_security_group_rule" "packer_egress_allow_all" {
  type = "egress"

  protocol  = -1
  from_port = 0
  to_port   = 0

  cidr_blocks = var.egress_cidr_blocks

  security_group_id = aws_security_group.packer.id
}