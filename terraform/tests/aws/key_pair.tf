resource "tls_private_key" "main" {
  algorithm = "RSA"
} 

resource "local_sensitive_file" "main" {
  filename        = "${var.key_pair_name}.pem"
  content         = tls_private_key.main.private_key_pem
  file_permission = "0400"
}

resource "aws_key_pair" "main" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.main.public_key_openssh
}