resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main.id

  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)
  availability_zone = var.availability_zone

  map_public_ip_on_launch = true
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

}

resource "aws_route" "main" {
  route_table_id = aws_route_table.main.id

  destination_cidr_block = var.igw_route_destination_cidr_block
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "main" {
  route_table_id = aws_route_table.main.id
  subnet_id      = aws_subnet.main.id
}

# Define the security group for HTTP web server
resource "aws_security_group" "main" {
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "ingress_allow_ssh" {
  type = "ingress"

  protocol  = "tcp"
  from_port = 22
  to_port   = 22

  cidr_blocks = concat(["${data.http.ip.response_body}/32"], var.ssh_allowed_ip_addresses)

  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "ingress_allow_http" {
  type = "ingress"

  protocol  = "tcp"
  from_port = 80
  to_port   = 80

  cidr_blocks = var.http_allowed_ip_addresses

  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "egress_allow_all" {
  type = "egress"

  protocol  = -1
  from_port = 0
  to_port   = 0

  cidr_blocks = var.egress_cidr_blocks

  security_group_id = aws_security_group.main.id
}