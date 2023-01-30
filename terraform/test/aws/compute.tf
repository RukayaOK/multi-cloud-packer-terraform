# Create Elastic IP for web server
resource "aws_eip" "main" {
  vpc = true
}

# Create EC2 Instances for Web Server
resource "aws_instance" "main" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.main.id
  vpc_security_group_ids      = [aws_security_group.main.id, aws_security_group.main.id]
  associate_public_ip_address = true
  source_dest_check           = false
  key_name                    = aws_key_pair.main.key_name
}

# Associate Elastic IP to Web Server
resource "aws_eip_association" "main" {
  instance_id   = aws_instance.main.id
  allocation_id = aws_eip.main.id
}

